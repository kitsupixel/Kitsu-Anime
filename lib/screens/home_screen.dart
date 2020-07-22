import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/shows.dart';
import '../data/episodes.dart';

import '../models/show.dart';
import '../models/episode.dart';

import '../widgets/shows_list.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool updatedLatest = false;

  @override
  Widget build(BuildContext context) {
    final showProvider = Provider.of<Shows>(context);

    List<Show> favoriteShows =
        showProvider.shows.where((element) => element.favorite).toList();

    favoriteShows.sort((a, b) => a.title.compareTo(b.title));

    List<Show> seenShows =
        showProvider.shows.where((element) => element.watched).toList();

    seenShows.sort((a, b) => a.title.compareTo(b.title));

    List<Show> ongoingShows =
        showProvider.shows.where((element) => element.ongoing).toList();

    ongoingShows.sort((a, b) => a.title.compareTo(b.title));

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            'Recent releases',
            style: Theme.of(context).textTheme.headline6.copyWith(),
          ),
        ),
        Consumer<Episodes>(builder: (ctx, episodeProvider, ch) {
          List<Show> recentShows = [];
          List<Episode> latestEpisodes = episodeProvider.latestEpisodes;
          for (var item in latestEpisodes) {
            recentShows.add(showProvider.shows
                .firstWhere((element) => element.id == item.showId));
          }

          return Container(
            width: double.infinity,
            height: 225,
            child: !episodeProvider.loading
                ? ShowsList(
                    shows: recentShows,
                    direction: Axis.horizontal,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        }),
        if (favoriteShows.length > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              'Your favorites',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        if (favoriteShows.length > 0)
          Container(
              width: double.infinity,
              height: 225,
              child: ShowsList(
                shows: favoriteShows,
                direction: Axis.horizontal,
              )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            'This season',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Container(
          width: double.infinity,
          height: 225,
          child: ongoingShows.length > 0
              ? ShowsList(
                  shows: ongoingShows,
                  direction: Axis.horizontal,
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        if (seenShows.length > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              'Your seen',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        if (seenShows.length > 0)
          Container(
              width: double.infinity,
              height: 225,
              child: ShowsList(
                shows: seenShows,
                direction: Axis.horizontal,
              )),
      ],
    );
  }
}
