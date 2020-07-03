import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/shows.dart';

import '../models/show.dart';

import '../widgets/shows_list.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  
  List<Show> _shows;

  @override
  Widget build(BuildContext context) {  
    _shows = Provider.of<Shows>(context).shows.where((element) => element.favorite).toList();

    return ShowsList(shows: _shows);
  }
}
