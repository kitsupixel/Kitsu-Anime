import 'package:flutter/foundation.dart';

import '../models/episode.dart';

class Episodes extends ChangeNotifier {
  List<Episode> _episodes;

  List<Episode> get episodes {
    return [..._episodes];
  }

  Episode getEpisode(int episodeId) {
    return _episodes.firstWhere((element) => element.id == episodeId);
  }

  List<Episode> getEpisodesByShow(int showId) {
    return _episodes.where((element) => element.showId == showId).toList();
  }

  Episodes() {
    _episodes = [
      Episode(
        id: 12,
        showId: 1,
        number: "12",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-20"),
        createdAt: DateTime.parse("2020-06-20 10:00:00")),
    Episode(
        id: 11,
        showId: 1,
        number: "11",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-19"),
        createdAt: DateTime.parse("2020-06-19 10:00:00")),
    Episode(
        id: 10,
        showId: 1,
        number: "10",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-18"),
        createdAt: DateTime.parse("2020-06-18 10:00:00")),
    Episode(
        id: 9,
        showId: 1,
        number: "9",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-17"),
        createdAt: DateTime.parse("2020-06-17 10:00:00")),
    Episode(
        id: 8,
        showId: 1,
        number: "8",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-16"),
        createdAt: DateTime.parse("2020-06-16 10:00:00")),
    Episode(
        id: 7,
        showId: 1,
        number: "7",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-15"),
        createdAt: DateTime.parse("2020-06-15 10:00:00")),
    Episode(
        id: 6,
        showId: 1,
        number: "6",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-14"),
        createdAt: DateTime.parse("2020-06-14 10:00:00")),
    Episode(
        id: 5,
        showId: 1,
        number: "5",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-13"),
        createdAt: DateTime.parse("2020-06-13 10:00:00")),
    Episode(
        id: 4,
        showId: 1,
        number: "4",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-12"),
        createdAt: DateTime.parse("2020-06-12 10:00:00")),
    Episode(
        id: 3,
        showId: 1,
        number: "3",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-11"),
        createdAt: DateTime.parse("2020-06-11 10:00:00")),
    Episode(
        id: 2,
        showId: 1,
        number: "2",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-10"),
        createdAt: DateTime.parse("2020-06-10 10:00:00")),
    Episode(
        id: 1,
        showId: 1,
        number: "1",
        type: "episode",
        releasedOn: DateTime.parse("2020-06-09"),
        createdAt: DateTime.parse("2020-06-09 10:00:00")),
    ];
  }
}
