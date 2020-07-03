import 'package:flutter/foundation.dart';

class Show {
  static const tableName = "Shows";
  static const dbId = "id";
  static const dbTitle = "title";
  static const dbSynopsis = "synopsis";
  static const dbThumbnail = "thumbnail";
  static const dbSeason = "season";
  static const dbYear = "year";
  static const dbOngoing = "ongoing";
  static const dbActive = "active";
  static const dbFavorite = "favorite";
  static const dbWatched = "watched";

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

  Show.fromMap(Map<String, dynamic> map): this(
    id: map[dbId],
    title: map[dbTitle],
    synopsis: map[dbSynopsis],
    thumbnail: map[dbThumbnail],
    season: map[dbSeason],
    year: map[dbYear],
    ongoing: map[dbOngoing] == 1,
    active: map[dbActive] == 1,
    favorite: map[dbFavorite] == 1,
    watched: map[dbWatched] == 1,
  );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      dbId: id,
      dbTitle: title,
      dbSynopsis: synopsis,
      dbThumbnail: thumbnail,
      dbSeason: season,
      dbYear: year,
      dbOngoing: ongoing ? 1 : 0,
      dbActive: active ? 1 : 0,
      dbFavorite: favorite ? 1 : 0,
      dbWatched: watched ? 1 : 0,
    };
  }
}
