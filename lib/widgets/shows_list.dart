import 'package:flutter/material.dart';

import '../models/show.dart';

import './show_item.dart';

class ShowsList extends StatelessWidget {
  const ShowsList({
    Key key,
    @required List<Show> shows,
    Axis direction
  })  : _shows = shows,
        _direction = direction,
        super(key: key);

  final List<Show> _shows;

  final Axis _direction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: this._direction != null ? 3.6 / 2.0 : 2.0 / 3.6,
          maxCrossAxisExtent: this._direction != null ? 300 : 150,
        ),
        scrollDirection: this._direction != null ? this._direction : Axis.vertical,
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
