import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/episodes.dart';

import '../models/episode.dart';

import '../widgets/latest_episode_item.dart';

class LatestScreen extends StatefulWidget {
  static const routeName = '/shows/latest';

  @override
  _LatestScreenState createState() => _LatestScreenState();
}

class _LatestScreenState extends State<LatestScreen> {
  bool calledUpdate = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

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

  Future _refreshList(Episodes episodeProvider) async {
    await episodeProvider.updateLatestEpisodes();
  }

  @override
  Widget build(BuildContext context) {
    final episodeProvider = Provider.of<Episodes>(context);

    if (!calledUpdate) {
      episodeProvider.updateLatestEpisodes();
      calledUpdate = true;
    }

    List<Episode> episodes = episodeProvider.latestEpisodes;

    episodes.sort((a, b) => _sortEpisodes(a, b));

    return RefreshIndicator(
      onRefresh: () => _refreshList(episodeProvider),
      key: refreshKey,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 3.0 / 1.0,
          maxCrossAxisExtent: 500,
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
    );
  }
}
