import 'package:music_mood_matcher/models/recommendation/recommendation.dart';

class JSONtoRecommendations {
  static List<Recommendation> parseJSON(Map<String, dynamic> json) {
    return _parseRecommendations(json);
  }

  static List<Recommendation> _parseRecommendations(Map<String, dynamic> json) {
    return [
      ..._parseItems(json['tracks']),
      ..._parseItems(json['albums']),
      ..._parseItems(json['artists']),
      ..._parseItems(json['playlists'])
    ];
  }

  static List<Recommendation> _parseItems(Map<String, dynamic> json) {
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
