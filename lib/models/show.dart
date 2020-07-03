import 'package:flutter/foundation.dart';

class Show {
  int id;
  String title;
  String synopsis;
  String thumbnail;
  String season;
  int year;
  bool ongoing;
  bool active;
  bool favorite = false;
  bool watched = false;

  Show({
    @required this.id,
    @required this.title,
    @required this.synopsis,
    @required this.thumbnail,
    @required this.season,
    @required this.year,
    @required this.ongoing,
    @required this.active,
    this.favorite = false,
    this.watched = false,
  });

  Show.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    synopsis = json['synopsis'];
    thumbnail = json['thumbnail'];
    season = json['season'];
    year = int.parse(json['year']);
    ongoing = int.parse(json['ongoing']) == 1;
    active = int.parse(json['active']) == 1;
  }
}
