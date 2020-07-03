import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


import '../models/show.dart';

class Shows extends ChangeNotifier {
  List<Show> _shows = [];

  List<Show> get shows {
    return [..._shows];
  }

  List<Show> get currentSeason {
    DateTime now = new DateTime.now();
    String currentSeason;

    if (now.month <= 3) currentSeason = 'Winter';
    else if (now.month <= 6) currentSeason = 'Spring';
    else if (now.month <= 9) currentSeason = 'Summer';
    else currentSeason = 'Fall';

    print(now.month.toString() + " " + currentSeason + " " + now.year.toString());

    return _shows.where((element) => (element.season == currentSeason && element.year == now.year) || element.ongoing).toList();
  }

  void _fetchShows() async {
    final response =
        await http.get('https://kpplus.kitsupixel.pt/api/v1/shows');

    if (response.statusCode == 200) {
      final jsonDecoded = json.decode(response.body);
      for (var i = 0; i < jsonDecoded['data'].length; i++) {
        var newShow = Show.fromJson(jsonDecoded['data'][i]);
        var oldShow = _shows.firstWhere((element) => element.id == newShow.id, orElse: () => null);
        if (oldShow != null) {
          var index = _shows.indexOf(oldShow);

          _shows[index].title = newShow.title;
          _shows[index].synopsis = newShow.synopsis;
          _shows[index].thumbnail = newShow.thumbnail;
          _shows[index].season = newShow.season;
          _shows[index].year = newShow.year;
          _shows[index].ongoing = newShow.ongoing;
          _shows[index].active = oldShow.active;
        } else {
          _shows.add(newShow);
        }
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Erro!');
    }

    _shows = shows;
    notifyListeners();
  }

  Show getShow(int showId) {
    return _shows.firstWhere((element) => element.id == showId, orElse: () => null);
  }

  Shows() {
    _fetchShows();
  }

  void toggleFavorite(int showId) {
    Show show = getShow(showId);
    if (show != null) {
      int index = _shows.indexOf(show);
      _shows[index].favorite = !_shows[index].favorite;
      notifyListeners();
    } else {
      throw new Exception("The show $showId wasn't found!");
    }
  }

  void toggleWatched(int showId) {
    Show show = getShow(showId);
    if (show != null) {
      int index = _shows.indexOf(show);
      _shows[index].watched = !_shows[index].watched;
      notifyListeners();
    } else {
      throw new Exception("The show $showId wasn't found!");
    }
  }
}
