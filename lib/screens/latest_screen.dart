import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/episodes.dart';

import '../models/episode.dart';

import '../widgets/latest_episode_item.dart';

class LatestScreen extends StatelessWidget {
  static const routeName = '/shows/latest';

  int _sortEpisodes(Episode a, Episode b) {
    int comparator = 0;

    if (b.releasedOn.isAfter(a.releasedOn))
      comparator = 1;
    else if (b.releasedOn.isAtSameMomentAs(a.releasedOn)) {
      comparator = b.id.compareTo(a.id);
    } else
      comparator = -1;

    return comparator;
  }

  @override
  Widget build(BuildContext context) {
    final episodeProvider = Provider.of<Episodes>(context);

    List<Episode> episodes = episodeProvider.latestEpisodes;

    episodes.sort((a, b) => _sortEpisodes(a, b));

    return Stack(children: [
      GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 3.0 / 1.0,
          maxCrossAxisExtent: 360,
        ),
        itemCount: episodes.length,
        itemBuilder: (ctx, index) {
          return LatestEpisodeItem(
            showId: episodes[index].showId,
            number: episodes[index].number,
            released: episodes[index].releasedOn,
          );
        },
      ),
      Consumer<Episodes>(
        builder: (ctx, data, ch) {
          return data.loading ? LinearProgressIndicator() : SizedBox();
        },
      )
    ]);
  }
}
