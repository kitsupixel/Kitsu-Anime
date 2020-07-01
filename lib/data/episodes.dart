import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/episode.dart';

class Episodes extends ChangeNotifier {
  List<Episode> _episodes = [];

  List<Episode> get episodes {
    return [..._episodes];
  }

  Episode getEpisode(int episodeId) {
    return _episodes.firstWhere((element) => element.id == episodeId);
  }

  List<Episode> getEpisodesByShow(int showId) {
    List<Episode> response = _episodes.where((element) => element.showId == showId).toList();
    if (response.length == 0) {
      _fetchShowEpisodes(showId);
    }
    return response;
  }

  void _fetchShowEpisodes(int showId) async {
    final response =
        await http.get('https://kpplus.kitsupixel.pt/api/v1/shows/$showId/episodes');

    final List<Episode> episodes = [];
    if (response.statusCode == 200) {
      final jsonDecoded = json.decode(response.body);
      for (var i = 0; i < jsonDecoded['data'].length; i++) {
        episodes.add(Episode.fromJson(jsonDecoded['data'][i]));
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Erro!');
    }

    _episodes = episodes;
    notifyListeners();
  }

  Episodes();
}
