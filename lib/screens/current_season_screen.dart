import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/shows.dart';

import '../models/show.dart';

import '../widgets/shows_list.dart';

class CurrentSeasonScreen extends StatelessWidget {
  static const routeName = '/shows/ongoing';
  
  List<Show> _shows;

  @override
  Widget build(BuildContext context) {  
    _shows = Provider.of<Shows>(context).currentSeason;

    return ShowsList(shows: _shows);
  }
}
