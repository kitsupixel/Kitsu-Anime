import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/shows.dart';

import '../widgets/shows_list.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final _shows = Provider.of<Shows>(context)
        .shows
        .where((element) => element.favorite)
        .toList();

    _shows.sort((a, b) => a.title.compareTo(b.title));

    return _shows.length > 0
        ? ShowsList(shows: _shows)
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'No favorites added yet... ;(',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
