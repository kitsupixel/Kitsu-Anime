import 'package:flutter/material.dart';

import '../data/episodes.dart';

import './ink_wrapper.dart';

class EpisodeDetailItem extends StatelessWidget {
  final String quality;
  final String type;
  final int seeds;
  final int leeches;
  final Function onTapCallback;

  EpisodeDetailItem({
    Key key,
    @required this.quality,
    @required this.type,
    @required this.onTapCallback,
    this.seeds,
    this.leeches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWrapper(
      onTap: () => this.onTapCallback(),
      child: Container(
        //decoration: BoxDecoration(color: Colors.blue),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: this.quality == "1080p"
                      ? Colors.blue
                      : this.quality == "720p" ? Colors.red : Colors.purple),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  this.quality,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: this.type == 'Torrent' ? 10.0 : 18.0),
                  child: Text(
                    this.type,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 16),
                  ),
                ),
                (this.type == 'Torrent')
                    ? Text(
                        "Seeders: ${this.seeds}/ Leeches: ${this.leeches}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.grey, fontSize: 12),
                      )
                    : SizedBox()
              ],
            ))
          ],
        ),
      ),
    );
  }
}
