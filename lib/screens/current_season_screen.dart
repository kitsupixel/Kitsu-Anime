import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/shows.dart';

import '../widgets/shows_list.dart';

class CurrentSeasonScreen extends StatelessWidget {
  static const routeName = '/shows/ongoing';

  @override
  Widget build(BuildContext context) {
    final _shows = Provider.of<Shows>(context).currentSeason;

    _shows.sort((a, b) => a.title.compareTo(b.title));

    return ShowsList(shows: _shows);
  }
}
