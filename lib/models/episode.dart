import 'package:flutter/foundation.dart';

class Episode {
  static const tableName = "Episodes";
  static const dbId = "id";
  static const dbShowId = "show_id";
  static const dbNumber = "number";
  static const dbType = "type";
  static const dbReleasedOn = "released_on";
  static const dbCreatedAt = "created_at";
  static const dbDownloaded = "downloaded";
  static const dbWatched = "watched";

  int id;
  int showId;
  String number;
  String type;
  DateTime releasedOn;
  DateTime createdAt;
  bool downloaded = false;
  bool watched = false;

  Episode({
    @required this.id,
    @required this.showId,
    @required this.number,
    @required this.type,
    @required this.releasedOn,
    @required this.createdAt,
    this.downloaded = false,
    this.watched = false,
  });

  Episode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    showId = int.parse(json['show_id']);
    number = json['number'];
    type = json['type'];
    releasedOn = DateTime.parse(json['released_on']);
    createdAt = DateTime.parse(json['created_at']);
  }

  Episode.fromMap(Map<String, dynamic> map): this(
    id: map[dbId],
    showId: map[dbShowId],
    number: map[dbNumber],
    type: map[dbType],
    releasedOn: DateTime.parse(map[dbReleasedOn]),
    createdAt: DateTime.parse(map[dbCreatedAt]),
    downloaded: map[dbDownloaded] == 1,
    watched: map[dbWatched] == 1,
  );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      dbId: id,
      dbShowId: showId,
      dbNumber: number,
      dbType: type,
      dbReleasedOn: releasedOn.toString(),
      dbCreatedAt: createdAt.toString(),
      dbDownloaded: downloaded ? 1 : 0,
      dbWatched: watched ? 1 : 0,
    };
  }
}
