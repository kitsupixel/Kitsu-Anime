import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/link.dart';

class Links extends ChangeNotifier {
  List<Link> _links = [];

  List<Link> get links {
    return [..._links];
  }

  Link getLink(int linkId) {
    return _links.firstWhere((element) => element.id == linkId);
  }

  List<Link> getLinksByEpisode(int showId,int episodeId) {
    List<Link> response = _links.where((element) => element.episodeId == episodeId).toList();
    if (response.length == 0) {
      _fetchEpisodeLinks(showId, episodeId);
    }
    return response;
  }

  void _fetchEpisodeLinks(int showId, int episodeId) async {
    final response =
        await http.get('https://kpplus.kitsupixel.pt/api/v1/shows/$showId/episodes/$episodeId');

    final List<Link> links = [];
    if (response.statusCode == 200) {
      final jsonDecoded = json.decode(response.body);
      for (var i = 0; i < jsonDecoded['data'].length; i++) {
        links.add(Link.fromJson(jsonDecoded['data'][i]));
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Erro!');
    }

    _links = links;
    notifyListeners();
  }

  Links();
}
