import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;

import '../models/episode.dart';
import '../models/link.dart';

import '../data/episodes.dart';
import '../data/links.dart';

import '../widgets/episode_detail_item.dart';

class EpisodeDetailScreen extends StatelessWidget {
  static const routeName = '/shows/detail/episode';

  EpisodeDetailScreen();

  _errorSnackBar(Exception e, BuildContext context) {
    Scaffold.of(context);
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text('Could open the link...' + e.toString()),
        action: SnackBarAction(
            label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
    print(e.toString());
  }

  _launchURL(String url, BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        android_intent.Intent()
          ..setAction(android_action.Action.ACTION_VIEW)
          ..setData(Uri.parse(url))
          ..startActivity();
      } else {
        // Se não for android vamos tentar abrir o browser para
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          _errorSnackBar(Exception("Can't lauch the url"), context);
        }
      }
    } catch (e) {
      _errorSnackBar(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final episodeId = ModalRoute.of(context).settings.arguments as int;

    var episodeProvider = Provider.of<Episodes>(context, listen: false);

    var mediaQuery = MediaQuery.of(context);

    Episode episode = episodeProvider.getEpisode(episodeId);

    List<Link> links = Provider.of<Links>(context)
        .getLinksByEpisode(episode.showId, episode.id);

    return Scaffold(
      appBar: AppBar(
        title: Text((episode.type == 'episode' ? "Episode " : "Batch ") +
            episode.number),
      ),
      body: links.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      mediaQuery.orientation == Orientation.portrait ? 1 : 2,
                  childAspectRatio: 50 / 10),
              itemCount: links.length,
              itemBuilder: (ctx, i) {
                return EpisodeDetailItem(
                  quality: links[i].quality,
                  type: links[i].type,
                  seeds: links[i].seeds,
                  leeches: links[i].leeches,
                  onTapCallback: () {
                    _launchURL(links[i].link, ctx);
                    episodeProvider.markAsDownloaded(links[i].episodeId);
                  },
                );
              },
            ),
    );
  }
}
