import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meet_network_image/meet_network_image.dart';

import '../data/shows.dart';

import '../models/show.dart';

import '../widgets/show_item.dart';

class AllShowsScreen extends StatelessWidget {
  static const routeName = '/shows';
  List<Show> _shows;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Shows>(context);
    _shows = provider.shows;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _shows.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 2.0 / 3.45,
                maxCrossAxisExtent: 200,
              ),
              itemCount: _shows.length,
              itemBuilder: (ctx, i) {
                return ShowItem(
                  id: _shows[i].id,
                  title: _shows[i].title,
                  thumbnail: _shows[i].thumbnail,
                  favorite: _shows[i].favorite,
                  watched: _shows[i].watched,
                );
              },
            ),
    );
  }
}
