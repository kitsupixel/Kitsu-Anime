import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../data/shows.dart';
import '../data/episodes.dart';

import '../models/show.dart';
import '../models/episode.dart';

import '../widgets/show_episode_item.dart';

class ShowDetailScreen extends StatelessWidget {
  static const routeName = '/shows/detail';

  int _sortEpisodes(Episode a, Episode b) {
    int comparator = 0;

    if (b.type == 'batch' && a.type == 'episode')
      comparator = -1;
    else if (b.type == 'episode' && a.type == 'batch')
      comparator = 1;
    else if (a.type == b.type) {
      if (a.type == 'batch') {
        comparator = b.number.compareTo(a.number);
      } else {
        if (a.number.contains("-")) a.number = a.number.replaceFirst("-", ".");
        if (b.number.contains("-")) b.number = b.number.replaceFirst("-", ".");
        comparator = double.parse(b.number).compareTo(double.parse(a.number));
      }
    }

    return comparator;
  }

  @override
  Widget build(BuildContext context) {
    final showId = ModalRoute.of(context).settings.arguments as int;

    Show show = Provider.of<Shows>(context, listen: false).getShow(showId);
    var episodeProvider = Provider.of<Episodes>(context, listen: false);

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 3 * mediaQuery.size.width / 2,
            // title: Text(show.title),
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: show.thumbnail,
                fit: BoxFit.fitHeight,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(Icons.error, color: Theme.of(context).errorColor),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<Shows>(builder: (ctx, showProvider, ch) {
                      return FloatingActionButton(
                        heroTag: "btnWatched",
                        mini: true,
                        tooltip: "Watched",
                        backgroundColor:
                            showProvider.getShow(showId).watched == true
                                ? Colors.blue[600]
                                : Colors.grey,
                        child: Icon(Icons.remove_red_eye),
                        onPressed: () => showProvider.toggleWatched(showId),
                      );
                    }),
                    SizedBox(
                      width: 8,
                    ),
                    Consumer<Shows>(builder: (ctx, showProvider, _) {
                      return FloatingActionButton(
                        heroTag: "btnFavorite",
                        mini: true,
                        tooltip: "Favorite",
                        backgroundColor:
                            showProvider.getShow(showId).favorite == true
                                ? Theme.of(context).accentColor
                                : Colors.grey,
                        child: Icon(Icons.star),
                        onPressed: () => showProvider.toggleFavorite(showId),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  show.title,
                  style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  show.synopsis,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Consumer<Episodes>(
                builder: (ctx, episodeData, ch) {
                  return episodeData.loading
                      ? Padding(
                          padding: EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: CircularProgressIndicator()),
                              SizedBox(width: 10),
                              Text(
                                'Updating episodes...\nPlease wait...',
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: () =>
                                  episodeProvider.updateShowEpisodes(showId),
                              child: Text(
                                'Press here to refresh episodes',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        );
                },
              ),
            ]),
          ),
          Consumer<Episodes>(
            builder: (ctx, episodeData, ch) {
              final episodes = episodeData.getEpisodesByShow(showId);

              episodes.sort((a, b) => _sortEpisodes(a, b));

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    return ShowEpisodeItem(episodes[i].id);
                  },
                  childCount: episodes.length,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
