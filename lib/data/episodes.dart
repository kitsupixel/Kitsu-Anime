import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './database.dart';
import './shows.dart';

import '../models/show.dart';
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
    if (_latestEpisodes.length == 0) {
      _fetchLatestEpisodes();
    }
    return _latestEpisodes;
  }

  Episode getEpisode(int episodeId) {
    return _episodes.firstWhere((element) => element.id == episodeId,
        orElse: () => null);
  }

  List<Episode> getEpisodesByShow(int showId) {
    List<Episode> response =
        _episodes.where((element) => element.showId == showId).toList();
    if (response.length == 0) {
      _fetchShowEpisodes(showId);
    }
    return response;
  }

  void updateShowEpisodes(int showId) {
    _fetchShowEpisodes(showId);
  }

  void _fetchShowEpisodes(int showId) async {
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

      await _db.db.transaction((txn) async {
        var batch = txn.batch();

        for (var i = 0; i < jsonEpisodes.length; i++) {
          var newEpisode = Episode.fromJson(jsonEpisodes[i]);

          if (i > 0 && i % 100 == 0) {
            await batch.commit();
            batch = txn.batch();
          }
          // Alguns episodios vem com a nomenclatura de 01-5 em vez de 01.5
          if (newEpisode.type == 'episode' && newEpisode.number.contains("-"))
            newEpisode.number = newEpisode.number.replaceFirst("-", ".");

          _db.getEpisode(newEpisode.id).then((oldEpisode) {
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
                  _db.updateEpisode(oldEpisode);
                  print("Updated episode: ${newEpisode.number}");
                  notifyListeners();
                }
              }
            } else {
              _episodes.add(newEpisode);
              _db.insertEpisode(newEpisode);
              print("Inserted episode: ${newEpisode.number}");
              notifyListeners();
            }
          });
        }

        await batch.commit();
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Erro!');
    }

    _loading = false;
    notifyListeners();
  }

  void _fetchLatestEpisodes() async {
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

      await _db.db.transaction((txn) async {
        var batch = txn.batch();

        for (var i = 0; i < jsonEpisodes.length; i++) {
          var newEpisode = Episode.fromJson(jsonEpisodes[i]);

          if (i > 0 && i % 100 == 0) {
            await batch.commit(continueOnError: true);
            batch = txn.batch();
          }

          // Alguns episodios vem com a nomenclatura de 01-5 em vez de 01.5
          if (newEpisode.type == 'episode' && newEpisode.number.contains("-"))
            newEpisode.number = newEpisode.number.replaceFirst("-", ".");

          var oldEpisode = _latestEpisodes.firstWhere(
              (element) => element.id == newEpisode.id,
              orElse: () => null);
          if (oldEpisode == null) {
            _db.getEpisode(newEpisode.id).then((oldEpisode) {
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
                    _db.updateEpisode(oldEpisode);
                    notifyListeners();
                    print("Updated episode: ${oldEpisode.number}");
                  }
                }
              } else {
                // Vamos verificar se existe o show deste novo episodio
                _db.getShow(newEpisode.showId).then((show) {
                  if (show == null) {
                    Shows.updateShow(newEpisode.showId);
                  }
                });
                _latestEpisodes.add(newEpisode);
                _latestEpisodes.removeLast();

                _db.insertEpisode(newEpisode);
                print("Inserted episode: ${newEpisode.number}");
                notifyListeners();
              }
            });
          }
        }

        await batch.commit(continueOnError: true);
      });
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
