import 'package:cached_network_image/cached_network_image.dart';
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
        Navigator.of(context)
            .pushNamed(ShowDetailScreen.routeName, arguments: id);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: CachedNetworkImage(
                imageUrl: thumbnail,
                fit: BoxFit.fitWidth,
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
                      .copyWith(fontSize: 11),
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
