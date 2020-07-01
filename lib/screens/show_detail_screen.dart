import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:meet_network_image/meet_network_image.dart';

import '../data/shows.dart';
import '../data/episodes.dart';

import '../models/show.dart';
import '../models/episode.dart';

import '../widgets/show_episode_item.dart';

class ShowDetailScreen extends StatelessWidget {
  static const routeName = '/shows/detail';

  @override
  Widget build(BuildContext context) {
    final showId = ModalRoute.of(context).settings.arguments as int;

    Show show = Provider.of<Shows>(context, listen: false).getShow(showId);

    AppBar appBarWidget = AppBar(
      title: Text(show.title),
      actions: [],
    );

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 3 * mediaQuery.size.width / 2,
            flexibleSpace: FlexibleSpaceBar(
              background: MeetNetworkImage(
                imageUrl: show.thumbnail,
                fit: BoxFit.fill,
                loadingBuilder: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, e) => Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
            actions: [
              IconButton(icon: Icon(Icons.remove_red_eye), onPressed: () {}),
              IconButton(icon: Icon(Icons.star), onPressed: () {})
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  show.title,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  show.synopsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ]),
          ),
          Consumer<Episodes>(
            builder: (ctx, episodeData, ch) {
              final episodes = episodeData.getEpisodesByShow(showId);
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
