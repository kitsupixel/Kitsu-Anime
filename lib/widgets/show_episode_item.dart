import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../data/episodes.dart';

import '../models/episode.dart';


class ShowEpisodeItem extends StatelessWidget {
  final int _episodeId;

  ShowEpisodeItem(this._episodeId);

  @override
  Widget build(BuildContext context) {
    final Episode _episode = Provider.of<Episodes>(context).getEpisode(_episodeId);

    return ListTile(
      onTap: () {
        print("Pressed the episode: " + _episode.number);
      },
      title: Text((_episode.type == 'episode'
              ? "Episode "
              : "Batch ") +
          _episode.number),
      subtitle: Text(DateFormat.yMd().format(_episode.releasedOn)),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () {
                print("Pressed the download: " + _episode.number);
              },
            ),
            IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                print("Pressed the watched: " + _episode.number);
              },
            ),
          ],
        ),
      ),
    );
  }
}
