import 'package:flutter/material.dart';
import 'package:kitsu_anime/screens/show_detail_screen.dart';
import 'package:meet_network_image/meet_network_image.dart';

import './ink_wrapper.dart';

class ShowItem extends StatelessWidget {

  final int id;
  final String title;
  final String thumbnail;
  final bool favorite;
  final bool watched;

  ShowItem({
    @required this.id,
    @required this.title,
    @required this.thumbnail,
    this.favorite = false,
    this.watched = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWrapper(
      onTap: () {
        Navigator.of(context).pushNamed(ShowDetailScreen.routeName, arguments: id);
      },
          child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: MeetNetworkImage(
                imageUrl: thumbnail,
                fit: BoxFit.fitWidth,
                loadingBuilder: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, e) => Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 5.0,
                ),
                child: Text(
                  title.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 13),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
