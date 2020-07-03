import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer/flutter_torrent_streamer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/episode.dart';
import '../models/link.dart';

import '../data/episodes.dart';
import '../data/links.dart';

import '../widgets/torrent_streamer_view.dart';

class EpisodeDetailScreen extends StatelessWidget {
  static const routeName = '/shows/detail/episode';

  const EpisodeDetailScreen({Key key}) : super(key: key);

  _watchEpisode(String url, BuildContext context) async {
    TorrentStreamer.init();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: TorrentStreamerView(url),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _launchURL(String url, BuildContext context) async {
    //TorrentStreamerView(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //throw 'Could not launch $url';
      Scaffold.of(context);
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Could open the link...'),
          action: SnackBarAction(
              label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final episodeId = ModalRoute.of(context).settings.arguments as int;

    Episode _episode =
        Provider.of<Episodes>(context, listen: false).getEpisode(episodeId);

    List<Link> _links = Provider.of<Links>(context)
        .getLinksByEpisode(_episode.showId, _episode.id);

    return Scaffold(
      appBar: AppBar(
        title: Text((_episode.type == 'episode' ? "Episode " : "Batch ") +
            _episode.number),
      ),
      body: _links.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _links.length,
              itemBuilder: (ctx, i) {
                return ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: _links[i].quality == "1080p"
                              ? Colors.blue
                              : _links[i].quality == "720p"
                                  ? Colors.red
                                  : Colors.purple),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _links[i].quality,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    title: Text(_links[i].type),
                    subtitle: (_links[i].type == 'Torrent')
                        ? Text(
                            "Seeders: ${_links[i].seeds}/ Leeches: ${_links[i].leeches}")
                        : null,
                    //onTap: () => _launchURL(_links[i].link, ctx));
                    onTap: () => _watchEpisode(_links[i].link, ctx));
              }),
    );
  }
}
