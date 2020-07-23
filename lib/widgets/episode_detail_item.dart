import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;

import './ink_wrapper.dart';

class EpisodeDetailItem extends StatelessWidget {
  final String quality;
  final String link;
  final String type;
  final int seeds;
  final int leeches;

  EpisodeDetailItem(
      {Key key, this.quality, this.link, this.type, this.seeds, this.leeches})
      : super(key: key);

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
    return InkWrapper(
      onTap: () {
        _launchURL(this.link, context);
        //   episodeProvider.markAsDownloaded(episodeId);
      },
      child: Container(
        //decoration: BoxDecoration(color: Colors.blue),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: this.quality == "1080p"
                      ? Colors.blue
                      : this.quality == "720p" ? Colors.red : Colors.purple),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  this.quality,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: this.type == 'Torrent' ? 10.0 : 18.0),
                  child: Text(
                    this.type,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 16),
                  ),
                ),
                (this.type == 'Torrent')
                    ? Text(
                        "Seeders: ${this.seeds}/ Leeches: ${this.leeches}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.grey, fontSize: 12),
                      )
                    : SizedBox()
              ],
            ))
          ],
        ),
      ),
    );
  }
}