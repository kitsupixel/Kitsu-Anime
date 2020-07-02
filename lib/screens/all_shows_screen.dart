import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/shows.dart';

import '../models/show.dart';

import '../widgets/shows_list.dart';

class AllShowsScreen extends StatelessWidget {
  static const routeName = '/shows';
  
  List<Show> _shows;

  @override
  Widget build(BuildContext context) {
    _shows = Provider.of<Shows>(context).shows;
    
    return ShowsList(shows: _shows);
  }
}
