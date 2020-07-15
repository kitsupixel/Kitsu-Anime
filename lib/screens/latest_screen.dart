import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/episodes.dart';

import '../models/episode.dart';

import '../widgets/latest_episode_item.dart';

class LatestScreen extends StatelessWidget {
  static const routeName = '/shows/latest';

  @override
  Widget build(BuildContext context) {
    final episodeProvider = Provider.of<Episodes>(context);

    List<Episode> episodes = episodeProvider.latestEpisodes;

    return ListView.builder(
      itemCount: episodes.length,
      //itemExtent: 100,
      itemBuilder: (ctx, index) {
        return LatestEpisodeItem(
          showId: episodes[index].showId,
          number: episodes[index].number,
          released: episodes[index].releasedOn,
        );
      },
    );
  }
}
