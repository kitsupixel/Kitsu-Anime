import 'package:flutter/material.dart';

import '../models/show.dart';

import './show_item.dart';

class ShowsList extends StatelessWidget {
  const ShowsList({
    Key key,
    @required List<Show> shows,
  }) : _shows = shows, super(key: key);

  final List<Show> _shows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: _shows.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 2.0 / 3.6,
                maxCrossAxisExtent: 150,
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
