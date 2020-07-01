import 'package:flutter/foundation.dart';

class Episode {
  int id;
  int showId;
  String number;
  String type;
  DateTime releasedOn;
  DateTime createdAt;
  bool downloaded;
  bool seen;

  Episode({
    @required this.id,
    @required this.showId,
    @required this.number,
    @required this.type,
    @required this.releasedOn,
    @required this.createdAt,
    this.downloaded = false,
    this.seen = false,
  });

  Episode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    showId = int.parse(json['show_id']);
    number = json['number'];
    type = json['type'];
    releasedOn = DateTime.parse(json['released_on']);
    createdAt = DateTime.parse(json['created_at']);
  }
}
