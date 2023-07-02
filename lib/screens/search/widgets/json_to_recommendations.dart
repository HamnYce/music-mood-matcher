import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:music_mood_matcher/models/recommendation/constants.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';

class JSONtoRecommendations {
  final void Function() finishedData;
  final void Function(List<Recommendation>) setRecs;

  JSONtoRecommendations({required this.finishedData, required this.setRecs}) {
    _jsons();
  }

  void _jsons() async {
    String jsonString = await rootBundle.loadString('assets/data/spotify.json');
    Map<String, dynamic> json = jsonDecode(jsonString);
    _parseRecommendations(json);

    finishedData();
  }

  void _parseRecommendations(Map<String, dynamic> json) {
    List<Recommendation> newRecs = [];
    int i = 0;

    for (var a in json['categories']['items']) {
      Recommendation rec = Recommendation(
          recommendationURL: a["href"],
          thumbnailURL: a['icons'][0]['url'],
          title: a['name'],
          category: categoryTypes[i % categoryTypes.length],
          liked: 0);
      newRecs.add(rec);
      i++;
    }
    setRecs(newRecs);
  }
}
