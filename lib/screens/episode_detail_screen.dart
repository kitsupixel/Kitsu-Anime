import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/episode.dart';
import '../models/link.dart';

import '../data/episodes.dart';
import '../data/links.dart';

import '../widgets/episode_detail_item.dart';

class EpisodeDetailScreen extends StatelessWidget {
  static const routeName = '/shows/detail/episode';

  EpisodeDetailScreen();

  @override
  Widget build(BuildContext context) {
    final episodeId = ModalRoute.of(context).settings.arguments as int;

    var episodeProvider = Provider.of<Episodes>(context, listen: false);

    var mediaQuery = MediaQuery.of(context);

    Episode episode = episodeProvider.getEpisode(episodeId);

    List<Link> links = Provider.of<Links>(context)
        .getLinksByEpisode(episode.showId, episode.id);

    return Scaffold(
      appBar: AppBar(
        title: Text((episode.type == 'episode' ? "Episode " : "Batch ") +
            episode.number),
      ),
      body: links.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      mediaQuery.orientation == Orientation.portrait ? 1 : 2,
                  childAspectRatio: 50 / 10),
              itemCount: links.length,
              itemBuilder: (ctx, i) {
                return EpisodeDetailItem(
                  episodeId: links[i].id,
                  quality: links[i].quality,
                  link: links[i].link,
                  type: links[i].type,
                  seeds: links[i].seeds,
                  leeches: links[i].leeches,
                  episodeProvider: episodeProvider,
                );
              },
            ),
    );
  }
}
