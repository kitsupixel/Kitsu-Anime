import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


import '../models/show.dart';

class Shows extends ChangeNotifier {
  List<Show> _shows = [];

  List<Show> get shows {
    return [..._shows];
  }

  void _fetchShows() async {
    final response =
        await http.get('https://kpplus.kitsupixel.pt/api/v1/shows');

    final List<Show> shows = [];
    if (response.statusCode == 200) {
      final jsonDecoded = json.decode(response.body);
      for (var i = 0; i < jsonDecoded['data'].length; i++) {
        shows.add(Show.fromJson(jsonDecoded['data'][i]));
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Erro!');
    }

    _shows = shows;
    notifyListeners();
  }

  Show getShow(int id) {
    return _shows.firstWhere((element) => element.id == id);
  }

  Shows() {
    _fetchShows();
  }
}
