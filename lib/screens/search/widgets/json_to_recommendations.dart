import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';

class JSONtoRecommendations {
  final void Function(List<Recommendation>) setRecs;

  JSONtoRecommendations({required this.setRecs}) {
    _jsons();
  }

  void _jsons() async {
    String jsonString = await rootBundle.loadString('assets/data/search.json');
    Map<String, dynamic> json = jsonDecode(jsonString);
    _parseRecommendations(json);
  }

  void _parseRecommendations(Map<String, dynamic> json) {
    List<Recommendation> newRecs = [
      ..._parseItems(json['tracks']),
      ..._parseItems(json['albums']),
      ..._parseItems(json['artists']),
      ..._parseItems(json['playlists'])
    ];
    setRecs(newRecs);
  }

  List<Recommendation> _parseItems(Map<String, dynamic> json) {
    List<Recommendation> recs = [];
    for (Map<String, dynamic> item in json['items']) {
      String id = item['id'];
      String recommendationURL = item['external_urls']['spotify'];
      String? thumbnailURL;
      String title = item['name'];
      String category = item['type'];
      List<dynamic> images =
          item['type'] == 'track' ? item['album']['images'] : item['images'];

      if (images.isNotEmpty) {
        thumbnailURL = images[0]['url'];
      }

      if (item['type'] == 'album') {
        category = item['album_type'] == 'single' ? 'track' : 'album';
      }

      recs.add(Recommendation(
          id: id,
          recommendationURL: recommendationURL,
          thumbnailURL: thumbnailURL,
          title: title,
          category: category));
    }
    return recs;
  }
}
