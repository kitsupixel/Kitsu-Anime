import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/shows.dart';
import '../data/filters.dart';
import '../models/show.dart';

import '../widgets/shows_list.dart';

class AllShowsScreen extends StatelessWidget {
  static const routeName = '/shows';

  @override
  Widget build(BuildContext context) {
    final showProvider = Provider.of<Shows>(context);

    List<Show> shows = showProvider.shows;

    // Search for shows
    int searchResult = shows.length;
    final search = Provider.of<Filters>(context).search;
    if (search.isNotEmpty) {
      shows = shows
          .where((element) =>
              element.title.toLowerCase().contains(search.toLowerCase()))
          .toList();
      searchResult = shows.length;
    }

    shows.sort((a, b) => a.title.compareTo(b.title));

    return Stack(children: [
      shows.length > 0
          ? ShowsList(shows: shows)
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  searchResult != 0
                      ? 'Something went wrong...\nPlease check your internet connection.'
                      : 'Oh no!\nNo results found!',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
      Consumer<Shows>(
        builder: (ctx, data, ch) {
          bool isLoading = data.loading;

          return isLoading ? LinearProgressIndicator() : SizedBox();
        },
      )
    ]);
  }
}
