import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../screens/episode_detail_screen.dart';

import '../data/episodes.dart';

import '../models/episode.dart';

class ShowEpisodeItem extends StatelessWidget {
  final int _episodeId;

  ShowEpisodeItem(this._episodeId);

  @override
  Widget build(BuildContext context) {
    final Episode _episode =
        Provider.of<Episodes>(context).getEpisode(_episodeId);

    return ListTile(
      onTap: () {
        Navigator.of(context)
            .pushNamed(EpisodeDetailScreen.routeName, arguments: _episodeId);
      },
      title: Text((_episode.type == 'episode' ? "Episode " : "Batch ") +
          _episode.number),
      subtitle: Text(
          DateFormat.yMd(Intl.getCurrentLocale()).format(_episode.releasedOn)),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            Consumer<Episodes>(builder: (ctx, episodeProvider, ch) {
              return IconButton(
                icon: Icon(
                  Icons.file_download,
                  color:
                      episodeProvider.getEpisode(_episodeId).downloaded == true
                          ? Colors.red[600]
                          : Theme.of(context).buttonColor,
                ),
                onPressed: () => episodeProvider.toggleDownloaded(_episodeId),
              );
            }),
            Consumer<Episodes>(builder: (ctx, episodeProvider, ch) {
              return IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: episodeProvider.getEpisode(_episodeId).watched == true
                      ? Colors.blue[600]
                      : Theme.of(context).buttonColor,
                ),
                onPressed: () => episodeProvider.toggleWatched(_episodeId),
              );
            }),
          ],
        ),
      ),
    );
  }
}
