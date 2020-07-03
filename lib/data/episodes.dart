import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './database.dart';

import '../models/episode.dart';

class Episodes extends ChangeNotifier {

  ShowDatabase _db;

  List<Episode> _episodes = [];

  List<Episode> get episodes {
    return [..._episodes];
  }

  Episode getEpisode(int episodeId) {
    return _episodes.firstWhere((element) => element.id == episodeId, orElse: () => null);
  }

  List<Episode> getEpisodesByShow(int showId) {
    List<Episode> response = _episodes.where((element) => element.showId == showId).toList();
    if (response.length == 0) {
      _fetchShowEpisodes(showId);
    }
    return response;
  }

  void _fetchShowEpisodes(int showId) async {
    bool somethingChanged = false;

    // First let's get the data from the database
    _db = ShowDatabase.get();
    _episodes = await _db.getEpisodes();
    if (_episodes.length > 0) {
      notifyListeners();
    }

    final response =
        await http.get('https://kpplus.kitsupixel.pt/api/v1/shows/$showId/episodes');

    if (response.statusCode == 200) {
      final jsonEpisodes = json.decode(response.body)['data'];
      for (var i = 0; i < jsonEpisodes.length; i++) {
        var newEpisode = Episode.fromJson(jsonEpisodes[i]);
        var oldEpisode = _episodes.firstWhere((element) => element.id == newEpisode.id, orElse: () => null);
        if (oldEpisode != null) {
          if (oldEpisode != newEpisode) {
            int index = _episodes.indexOf(oldEpisode);
            _episodes[index].showId = newEpisode.showId;
            _episodes[index].number = newEpisode.number;
            _episodes[index].type = newEpisode.type;
            _episodes[index].releasedOn = newEpisode.releasedOn;
            _episodes[index].createdAt = newEpisode.createdAt;
            somethingChanged = true;
            await _db.updateEpisode(_episodes[index]);
          }
        } else {
          somethingChanged = true;
          _episodes.add(newEpisode);
          await _db.insertEpisode(newEpisode);
        } 
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Erro!');
    }

    if (somethingChanged) {
      notifyListeners();
    }
  }

  Episodes();

  void toggleDownloaded(int episodeId) async {
    Episode episode = getEpisode(episodeId);
    if (episode != null) {
      int index = _episodes.indexOf(episode);
      _episodes[index].downloaded = !_episodes[index].downloaded;
      notifyListeners();
      await _db.updateEpisode(_episodes[index]);
    } else {
      throw new Exception("The episode $episodeId wasn't found!");
    }
  }

  void toggleWatched(int episodeId) async {
    Episode episode = getEpisode(episodeId);
    if (episode != null) {
      int index = _episodes.indexOf(episode);
      _episodes[index].watched = !_episodes[index].watched;
      notifyListeners();
      await _db.updateEpisode(_episodes[index]);
    } else {
      throw new Exception("The episode $episodeId wasn't found!");
    }
  }
}
