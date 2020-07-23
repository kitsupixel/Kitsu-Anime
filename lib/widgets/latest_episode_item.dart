import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../data/shows.dart';
import '../models/show.dart';

import '../screens/show_detail_screen.dart';

import './ink_wrapper.dart';

class LatestEpisodeItem extends StatelessWidget {
  final int showId;
  final String number;
  final DateTime released;

  LatestEpisodeItem(
      {@required this.showId, @required this.number, @required this.released});

  @override
  Widget build(BuildContext context) {
    Show show = Provider.of<Shows>(context, listen: false)
        .shows
        .firstWhere((element) => element.id == this.showId);

    return Container(
      height: 125,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4, right: 4, left: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          new BoxShadow(
              color: Colors.grey,
              offset: new Offset(0.0, 1.0),
              blurRadius: 1.0,
              spreadRadius: 1.0)
        ],
      ),
      child: InkWrapper(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ShowDetailScreen.routeName, arguments: this.showId);
        },
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: CachedNetworkImage(
                imageUrl: show.thumbnail,
                fit: BoxFit.fitHeight,
                placeholder: (context, url) => Image.asset(
                  'assets/images/noimage.png',
                  fit: BoxFit.fitWidth,
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(Icons.error, color: Theme.of(context).errorColor, size: 16.0,),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5, top: 35, right: 10, bottom: 5),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        show.title.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontSize: 16),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Episode " + this.number,
                              style: Theme.of(context).textTheme.bodyText2),
                          Text(DateFormat('yyyy-MM-dd').format(this.released),
                              style: Theme.of(context).textTheme.bodyText2),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
