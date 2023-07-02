import 'package:music_mood_matcher/models/recommendation/constants.dart';

class Recommendation {
  late final String id;
  late final String? thumbnailURL;
  late final String recommendationURL;
  late final String title;
  late final String category;
  int liked = -1;

  Recommendation(
      {required this.id,
      required this.recommendationURL,
      required this.thumbnailURL,
      required this.title,
      required this.category,
      this.liked = -1});

  Recommendation.fromMap(Map<String, Object?> map) {
    id = map[columnId] as String;
    thumbnailURL = map[columnThumbnailURL] as String?;
    recommendationURL = map[columnRecommendationURL] as String;
    title = map[columnTitle] as String;
    category = map[columnCategory] as String;
    liked = map[columnLiked] as int;
  }

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      columnId: id,
      columnThumbnailURL: thumbnailURL,
      columnRecommendationURL: recommendationURL,
      columnTitle: title,
      columnCategory: category,
      columnLiked: liked
    };
    return map;
  }

  void likeUnlike() {
    liked *= -1;
  }
}
