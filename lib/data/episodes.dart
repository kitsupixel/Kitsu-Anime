import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './database.dart';

import '../models/episode.dart';

class Episodes extends ChangeNotifier {
  ShowDatabase _db;

  List<Episode> _episodes = [];

  List<Episode> _latestEpisodes = [];

  List<Episode> get episodes {
    return [..._episodes];
  }

  bool _loading = false;

  bool get loading {
    return _loading;
  }

  List<Episode> get latestEpisodes {
    return [..._latestEpisodes];
  }
  
  Episode getEpisode(int episodeId) {
    return _episodes.firstWhere((element) => element.id == episodeId,
        orElse: () => null);
  }

  List<Episode> getEpisodesByShow(int showId) {
    return _episodes.where((element) => element.showId == showId).toList();
  }

  Future updateLatestEpisodes() async {
    await _fetchLatestEpisodes();
  }

  Future updateShowEpisodes(int showId) async {
    await _fetchShowEpisodes(showId);
  }

  Future _fetchShowEpisodes(int showId) async {
    print("Called _fetchShowEpisodes");
    _loading = true;

    // First let's get the data from the database
    _db = ShowDatabase.get();
    _episodes = await _db.getEpisodes();
    if (_episodes.length > 0) {
      notifyListeners();
    }

    final response = await http
        .get('https://kpplus.kitsupixel.pt/api/v1/shows/$showId/episodes');

    if (response.statusCode == 200) {
      final jsonEpisodes = json.decode(response.body)['data'];

      for (var i = 0; i < jsonEpisodes.length; i++) {
        var newEpisode = Episode.fromJson(jsonEpisodes[i]);
        // Alguns episodios vem com a nomenclatura de 01-5 em vez de 01.5
        if (newEpisode.type == 'episode' && newEpisode.number.contains("-"))
          newEpisode.number = newEpisode.number.replaceFirst("-", ".");

        var oldEpisode = await _db.getEpisode(newEpisode.id);
        if (oldEpisode != null) {
          bool somethingChanged = false;
          if (oldEpisode.showId != newEpisode.showId) {
            oldEpisode.showId = newEpisode.showId;
            somethingChanged = true;
          }

          if (oldEpisode.number != newEpisode.number) {
            oldEpisode.number = newEpisode.number;
            somethingChanged = true;
          }

          if (oldEpisode.type != newEpisode.type) {
            oldEpisode.type = newEpisode.type;
            somethingChanged = true;
          }

          if (oldEpisode.releasedOn != newEpisode.releasedOn) {
            oldEpisode.releasedOn = newEpisode.releasedOn;
            somethingChanged = true;
          }

          if (oldEpisode.createdAt != newEpisode.createdAt) {
            oldEpisode.createdAt = newEpisode.createdAt;
            somethingChanged = true;
          }
          if (somethingChanged) {
            await _db.updateEpisode(oldEpisode);
            print("Updated episode: ${newEpisode.number}");
          }
        } else {
          _episodes.add(newEpisode);

          await _db.insertEpisode(newEpisode);

          print("Inserted episode: ${newEpisode.number}");

          notifyListeners();
        }
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Erro!');
    }

    _loading = false;
    notifyListeners();
  }

  Future _fetchLatestEpisodes() async {
    print("Called _fetchLatestEpisodes");
    _loading = true;

    // First let's get the data from the database
    _db = ShowDatabase.get();
    _latestEpisodes = await _db.getLatestEpisodes();
    if (_latestEpisodes.length > 0) {
      notifyListeners();
    }

    final response =
        await http.get('https://kpplus.kitsupixel.pt/api/v1/shows/latest');

    if (response.statusCode == 200) {
      final jsonEpisodes = json.decode(response.body)['data'];

      for (var i = 0; i < jsonEpisodes.length; i++) {
        var newEpisode = Episode.fromJson(jsonEpisodes[i]);

        // Alguns episodios vem com a nomenclatura de 01-5 em vez de 01.5
        if (newEpisode.type == 'episode' && newEpisode.number.contains("-"))
          newEpisode.number = newEpisode.number.replaceFirst("-", ".");

        var oldEpisode = _latestEpisodes.firstWhere(
            (element) => element.id == newEpisode.id,
            orElse: () => null);
        if (oldEpisode == null) {
          var oldEpisode = await _db.getEpisode(newEpisode.id);
          if (oldEpisode != null) {
            if (oldEpisode != newEpisode) {
              bool somethingChanged = false;
              if (oldEpisode.showId != newEpisode.showId) {
                oldEpisode.showId = newEpisode.showId;
                somethingChanged = true;
              }

              if (oldEpisode.number != newEpisode.number) {
                oldEpisode.number = newEpisode.number;
                somethingChanged = true;
              }

              if (oldEpisode.type != newEpisode.type) {
                oldEpisode.type = newEpisode.type;
                somethingChanged = true;
              }

              if (oldEpisode.releasedOn != newEpisode.releasedOn) {
                oldEpisode.releasedOn = newEpisode.releasedOn;
                somethingChanged = true;
              }

              if (oldEpisode.createdAt != newEpisode.createdAt) {
                oldEpisode.createdAt = newEpisode.createdAt;
                somethingChanged = true;
              }

              if (somethingChanged) {
                await _db.updateEpisode(oldEpisode);
                print("Updated episode: ${oldEpisode.number}");
              }
            }
          } else {
            // Vamos verificar se existe o show deste novo episodio
            _latestEpisodes.add(newEpisode);

            if (_latestEpisodes.length > 15) _latestEpisodes.removeLast();

            await _db.insertEpisode(newEpisode);

            print("Inserted episode: ${newEpisode.number}");
          }
        }
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Erro!');
    }

    _loading = false;
    notifyListeners();
  }

  Episodes();

  void toggleDownloaded(int episodeId) async {
    print("Called toggleDownloaded");
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

  void markAsDownloaded(int episodeId) async {
    print("Called markAsDownloaded");
    Episode episode = getEpisode(episodeId);
    if (episode != null) {
      int index = _episodes.indexOf(episode);
      if (_episodes[index].downloaded != true) {
        _episodes[index].downloaded = true;
        notifyListeners();
        await _db.updateEpisode(_episodes[index]);
      }
    } else {
      throw new Exception("The episode $episodeId wasn't found!");
    }
  }

  void toggleWatched(int episodeId) async {
    print("Called toggleWatched");
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
