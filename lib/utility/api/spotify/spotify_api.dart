import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_mood_matcher/models/recommendation/constants.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_provider.dart';
import 'package:music_mood_matcher/screens/search/widgets/json_to_recommendations.dart';
import 'package:music_mood_matcher/utility/api/spotify/spotify_token.dart';

class SpotifyApi {
  final SpotifyToken _spotifyToken = SpotifyToken();
  final RecommendationProvider _db = RecommendationProvider();
  Future<String> get _token async => await _spotifyToken.getToken();
  // loads token regardless if its old or new

  SpotifyApi() {
    _db.open(databaseName);
  }

  // by default searches the category types we specified before
  Future search(String query) async {
    Uri searchUri = _createSearchUri(query);

    http.Response res = await http
        .get(searchUri, headers: {'Authorization': 'Bearer ${await _token}'});
    if (res.statusCode == 200) {
      Map<String, dynamic> json = await jsonDecode(res.body);
      List<Recommendation> recs = JSONtoRecommendations.parseJSON(json);
      await _db.insertNewSearched(recs);
      return;
    }
    throw 'Could not complete search through Spotify\' Search Api';
  }

  Uri _createSearchUri(String query) {
    Uri searchUri = Uri(
      scheme: 'https',
      host: 'api.spotify.com',
      pathSegments: ['v1', 'search'],
      queryParameters: {
        'q': query,
        'type': 'album,artist,track,playlist',
        'market': 'KW',
        'limit': '7'
      },
    );

    return searchUri;
  }
}
