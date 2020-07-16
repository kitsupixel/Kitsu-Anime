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
    bool somethingChanged = false;
    _loading = true;
    
    // First let's get the data from the database
    _db = ShowDatabase.get();
    _shows = await _db.getShows();
    if (_shows.length > 0) {
      notifyListeners();
    }

    // Then let's see if there were changes and update the db
    final response =
        await http.get('https://kpplus.kitsupixel.pt/api/v1/shows');

    if (response.statusCode == 200) {
      final jsonShows = json.decode(response.body)['data'];
      for (var i = 0; i < jsonShows.length; i++) {
        Show newShow = Show.fromJson(jsonShows[i]);
        Show oldShow = await _db.getShow(newShow.id);
        if (oldShow != null) {
          if (oldShow != newShow) {
            oldShow.title = newShow.title;
            oldShow.synopsis = newShow.synopsis;
            oldShow.thumbnail = newShow.thumbnail;
            oldShow.season = newShow.season;
            oldShow.year = newShow.year;
            oldShow.ongoing = newShow.ongoing;
            oldShow.active = oldShow.active;
            somethingChanged = true;
            await _db.updateShow(oldShow);
          }
        } else {
          somethingChanged = true;
          _shows.add(newShow);
          await _db.insertShow(newShow);
        }
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Erro!');
    }

    _loading = false;
    if (somethingChanged) {
      notifyListeners();
    }
  }

  static void updateShow(int showId) async {
    
    // First let's get the data from the database
    final db = ShowDatabase.get();
    Show oldShow = await db.getShow(showId);

    // Then let's see if there were changes and update the db
    final response =
        await http.get('https://kpplus.kitsupixel.pt/api/v1/shows/$showId');

    if (response.statusCode == 200) {
      final jsonShow = json.decode(response.body)['data'];
        Show newShow = Show.fromJson(jsonShow);
        if (oldShow != null) {
          if (oldShow != newShow) {
            oldShow.title = newShow.title;
            oldShow.synopsis = newShow.synopsis;
            oldShow.thumbnail = newShow.thumbnail;
            oldShow.season = newShow.season;
            oldShow.year = newShow.year;
            oldShow.ongoing = newShow.ongoing;
            oldShow.active = oldShow.active;
            await db.updateShow(oldShow);
          }
        } else {
          await db.insertShow(newShow);
        }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Erro!');
    }
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
