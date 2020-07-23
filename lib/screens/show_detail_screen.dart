import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../data/shows.dart';
import '../data/episodes.dart';

import '../models/show.dart';

import '../widgets/show_episode_list.dart';

class ShowDetailScreen extends StatelessWidget {
  static const routeName = '/shows/detail';

  Widget _buildBody(BuildContext context, Show show, Episodes episodeProvider) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            show.title,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.black),
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
                            episodeProvider.updateShowEpisodes(show.id),
                        child: Text(
                          'Press here to refresh episodes',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ]),
    );
  }

  Widget _buildFabs(BuildContext context, Show show) {
    return Stack(children: [
      Container(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer<Shows>(builder: (ctx, showProvider, ch) {
              return FloatingActionButton(
                heroTag: "btnWatched",
                mini: true,
                tooltip: "Watched",
                backgroundColor: showProvider.getShow(show.id).watched == true
                    ? Colors.blue[600]
                    : Colors.grey,
                child: Icon(Icons.remove_red_eye),
                onPressed: () => showProvider.toggleWatched(show.id),
              );
            }),
            SizedBox(
              width: 4,
            ),
            Consumer<Shows>(builder: (ctx, showProvider, _) {
              return FloatingActionButton(
                heroTag: "btnFavorite",
                mini: true,
                tooltip: "Favorite",
                backgroundColor: showProvider.getShow(show.id).favorite == true
                    ? Theme.of(context).accentColor
                    : Colors.grey,
                child: Icon(Icons.star),
                onPressed: () => showProvider.toggleFavorite(show.id),
              );
            }),
            SizedBox(
              width: 4,
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildPortrait(BuildContext context, Show show,
      MediaQueryData mediaQuery, Episodes episodeProvider) {
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
              title: _buildFabs(context, show),
            ),
          ),
          _buildBody(context, show, episodeProvider),
          ShowEpisodeList(
            showId: show.id,
          )
        ],
      ),
    );
  }

  Widget _buildLandscape(BuildContext context, Show show,
      MediaQueryData mediaQuery, Episodes episodeProvider) {
    return Scaffold(
      appBar: AppBar(
        actions: [_buildFabs(context, show)],
      ),
      body: Container(
        width: double.infinity,
        child: Row(
          children: [
            // Imagem
            Container(
              height: mediaQuery.size.height,
              decoration: BoxDecoration(color: Colors.blue),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: CachedNetworkImage(
                  imageUrl: show.thumbnail,
                  fit: BoxFit.fitHeight,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child:
                        Icon(Icons.error, color: Theme.of(context).errorColor),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: CustomScrollView(
                slivers: [
                  _buildBody(context, show, episodeProvider),
                  ShowEpisodeList(
                    showId: show.id,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showId = ModalRoute.of(context).settings.arguments as int;

    Show show = Provider.of<Shows>(context, listen: false).getShow(showId);

    var episodeProvider = Provider.of<Episodes>(context, listen: false);

    final mediaQuery = MediaQuery.of(context);

    return mediaQuery.orientation == Orientation.portrait
        ? _buildPortrait(context, show, mediaQuery, episodeProvider)
        : _buildLandscape(context, show, mediaQuery, episodeProvider);
  }
}
