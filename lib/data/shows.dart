import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './database.dart';

import '../models/show.dart';

class Shows extends ChangeNotifier {
  ShowDatabase _db;

  List<Show> _shows = [];

  List<Show> get shows {
    return [..._shows];
  }

  List<Show> get currentSeason {
    DateTime now = new DateTime.now();
    String currentSeason;

    if (now.month <= 3)
      currentSeason = 'Winter';
    else if (now.month <= 6)
      currentSeason = 'Spring';
    else if (now.month <= 9)
      currentSeason = 'Summer';
    else
      currentSeason = 'Fall';

    return _shows
        .where((element) =>
            (element.season == currentSeason && element.year == now.year) ||
            element.ongoing)
        .toList();
  }

  bool _loading = false;

  bool get loading {
    return _loading;
  }

  void _fetchShows() async {
    _loading = true;
    notifyListeners();

    // First let's get the data from the database
    _db = ShowDatabase.get();

    _shows = await _db.getShows();
    if (_shows.length > 0) {
      notifyListeners();
    }

    // Then let's see if there were changes and update the db
    final response =
        await http.get('https://kpplus.kitsupixel.pt/api/v1/shows');

    await _db.db.transaction((txn) async {
      var batch = txn.batch();

      if (response.statusCode == 200) {
        final jsonShows = json.decode(response.body)['data'];
        for (var i = 0; i < jsonShows.length; i++) {
          if (i > 0 && i % 100 == 0) {
            await batch.commit(continueOnError: true);
            batch = txn.batch();
          }

          Show newShow = Show.fromJson(jsonShows[i]);
          _db.getShow(newShow.id).then((oldShow) {
            if (oldShow != null) {
              if (oldShow != newShow) {
                bool somethingChanged = false;
                if (oldShow.title != newShow.title) {
                  oldShow.title = newShow.title;
                  somethingChanged = true;
                }

                if (oldShow.synopsis != newShow.synopsis) {
                  oldShow.synopsis = newShow.synopsis;
                  somethingChanged = true;
                }

                if (oldShow.thumbnail != newShow.thumbnail) {
                  oldShow.thumbnail = newShow.thumbnail;
                  somethingChanged = true;
                }

                if (oldShow.season != newShow.season) {
                  oldShow.season = newShow.season;
                  somethingChanged = true;
                }

                if (oldShow.year != newShow.year) {
                  oldShow.year = newShow.year;
                  somethingChanged = true;
                }

                if (oldShow.ongoing != newShow.ongoing) {
                  oldShow.ongoing = newShow.ongoing;
                  somethingChanged = true;
                }

                if (oldShow.active != newShow.active) {
                  oldShow.active = newShow.active;
                  somethingChanged = true;
                }

                if (oldShow.title != newShow.title) {
                  oldShow.title = newShow.title;
                  somethingChanged = true;
                }

                if (somethingChanged) {
                  _db.updateShow(oldShow);
                  print("Updated show: ${oldShow.title}");
                  notifyListeners();
                }
              }
            } else {
              _shows.add(newShow);
              _db.insertShow(newShow);
              print("Inserted show: ${newShow.title}");
              notifyListeners();
            }
          });
        }

        await batch.commit(continueOnError: true);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Erro!');
      }
    });

    _loading = false;
    notifyListeners();
  }

  static void updateShow(int showId) async {
    // Then let's see if there were changes and update the db
    final response =
        await http.get('https://kpplus.kitsupixel.pt/api/v1/shows/$showId');

    // First let's get the data from the database
    final db = ShowDatabase.get();
    db.getShow(showId).then((oldShow) {
      if (response.statusCode == 200) {
        final jsonShow = json.decode(response.body)['data'];
        Show newShow = Show.fromJson(jsonShow);
        if (oldShow != null) {
          if (oldShow != newShow) {
            bool somethingChanged = false;

            if (oldShow.title != newShow.title) {
              oldShow.title = newShow.title;
              somethingChanged = true;
            }

            if (oldShow.synopsis != newShow.synopsis) {
              oldShow.synopsis = newShow.synopsis;
              somethingChanged = true;
            }

            if (oldShow.thumbnail != newShow.thumbnail) {
              oldShow.thumbnail = newShow.thumbnail;
              somethingChanged = true;
            }

            if (oldShow.season != newShow.season) {
              oldShow.season = newShow.season;
              somethingChanged = true;
            }

            if (oldShow.year != newShow.year) {
              oldShow.year = newShow.year;
              somethingChanged = true;
            }

            if (oldShow.ongoing != newShow.ongoing) {
              oldShow.ongoing = newShow.ongoing;
              somethingChanged = true;
            }

            if (oldShow.active != newShow.active) {
              oldShow.active = newShow.active;
              somethingChanged = true;
            }

            if (oldShow.title != newShow.title) {
              oldShow.title = newShow.title;
              somethingChanged = true;
            }

            if (somethingChanged) {
              db.updateShow(oldShow);
              print("Updated show: ${oldShow.title}");
            }
          }
        } else {
          db.insertShow(newShow);
          print("Inserted show: ${newShow.title}");
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Erro!');
      }
    });
  }

  Show getShow(int showId) {
    return _shows.firstWhere((element) => element.id == showId,
        orElse: () => null);
  }

  Shows() {
    _fetchShows();
  }

  void toggleFavorite(int showId) async {
    Show show = getShow(showId);
    if (show != null) {
      int index = _shows.indexOf(show);
      _shows[index].favorite = !_shows[index].favorite;
      notifyListeners();
      await _db.updateShow(_shows[index]);
    } else {
      throw new Exception("The show $showId wasn't found!");
    }
  }

  void toggleWatched(int showId) async {
    Show show = getShow(showId);
    if (show != null) {
      int index = _shows.indexOf(show);
      _shows[index].watched = !_shows[index].watched;
      notifyListeners();
      await _db.updateShow(_shows[index]);
    } else {
      throw new Exception("The show $showId wasn't found!");
    }
  }
}
