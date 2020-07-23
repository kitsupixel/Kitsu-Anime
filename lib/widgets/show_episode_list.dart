import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/episode.dart';

import '../data/episodes.dart';

import './show_episode_item.dart';

class ShowEpisodeList extends StatefulWidget {
  ShowEpisodeList({Key key, this.showId}) : super(key: key);

  final showId;

  @override
  _ShowEpisodeList createState() => _ShowEpisodeList();
}

class _ShowEpisodeList extends State<ShowEpisodeList> {
  bool calledUpdate = false;

  int _sortEpisodes(Episode a, Episode b) {
    int comparator = 0;

    if (b.type == 'batch' && a.type == 'episode')
      comparator = -1;
    else if (b.type == 'episode' && a.type == 'batch')
      comparator = 1;
    else if (a.type == b.type) {
      if (a.type == 'batch') {
        comparator = b.number.compareTo(a.number);
      } else {
        if (a.number.contains("-")) a.number = a.number.replaceFirst("-", ".");
        if (b.number.contains("-")) b.number = b.number.replaceFirst("-", ".");
        double aNumber = double.tryParse(a.number);
        double bNumber = double.tryParse(b.number);
        if (aNumber != null && bNumber != null)
          comparator = bNumber.compareTo(aNumber);
        else
          comparator = b.number.compareTo(a.number);
      }
    }

    return comparator;
  }

  @override
  Widget build(BuildContext context) {
    final episodeProvider = Provider.of<Episodes>(context);

    if (!calledUpdate) {
      episodeProvider.updateShowEpisodes(widget.showId);
      calledUpdate = true;
    }

    final episodes = episodeProvider.getEpisodesByShow(widget.showId);

    episodes.sort((a, b) => _sortEpisodes(a, b));

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) {
          return ShowEpisodeItem(episodes[i].id);
        },
        childCount: episodes.length,
      ),
    );
  }
}
