import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../data/shows.dart';
import '../data/episodes.dart';

import '../models/show.dart';

import '../widgets/show_episode_item.dart';

class ShowDetailScreen extends StatelessWidget {
  static const routeName = '/shows/detail';

  @override
  Widget build(BuildContext context) {
    final showId = ModalRoute.of(context).settings.arguments as int;

    Show show = Provider.of<Shows>(context, listen: false).getShow(showId);

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 3 * mediaQuery.size.width / 2,
            title: Text(show.title),
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
            ),
            actions: [
              Consumer<Shows>(builder: (ctx, showProvider, ch) {
                return IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: showProvider.getShow(showId).watched == true
                        ? Colors.blue[600]
                        : Colors.white,
                  ),
                  onPressed: () => showProvider.toggleWatched(showId),
                );
              }),
              Consumer<Shows>(builder: (ctx, showProvider, ch) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: showProvider.getShow(showId).favorite == true
                        ? Colors.red[600]
                        : Colors.white,
                  ),
                  onPressed: () => showProvider.toggleFavorite(showId),
                );
              }),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  show.title,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  show.synopsis,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ]),
          ),
          Consumer<Episodes>(
            builder: (ctx, episodeData, ch) {
              final episodes = episodeData.getEpisodesByShow(showId);

              return episodes.length == 0
                  ? SliverToBoxAdapter(
                      child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Center(child: CircularProgressIndicator()),
                    ))
                  : SliverList(
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
