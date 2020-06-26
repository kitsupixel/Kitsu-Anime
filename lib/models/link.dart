import 'package:flutter/foundation.dart';

class Link {
  int id;
  int episodeId;
  String type;
  String quality;
  String language;
  String link;
  int seeds;
  int leeches;
  int downloads;

  Link({
    @required this.id,
    @required this.episodeId,
    @required this.type,
    @required this.quality,
    @required this.language,
    @required this.link,
    @required this.seeds,
    @required this.leeches,
    @required this.downloads,
  });

  Link.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    episodeId = int.parse(json['episode_id']);
    type = json['type'];
    quality = json['quality'];
    language = json['language'];
    link = json['link'];
    seeds = int.parse(json['seeds']);
    leeches = int.parse(json['leeches']);
    downloads = int.parse(json['downloads']);
  }
}
