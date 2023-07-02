import 'package:music_mood_matcher/models/recommendation/constants.dart';

class Recommendation {
  int? id;
  late String thumbnailURL;
  late String recommendationURL;
  late String title;
  late String category;
  int liked = -1;

  Recommendation(
      {required this.recommendationURL,
      required this.thumbnailURL,
      required this.title,
      required this.category,
      this.liked = -1});

  Recommendation.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int;
    thumbnailURL = map[columnThumbnailURL] as String;
    recommendationURL = map[columnRecommendationURL] as String;
    title = map[columnTitle] as String;
    category = map[columnCategory] as String;
    liked = map[columnLiked] as int;
  }

  Map<String, Object> toMap() {
    Map<String, Object> map = {
      columnThumbnailURL: thumbnailURL,
      columnRecommendationURL: recommendationURL,
      columnTitle: title,
      columnCategory: category,
      columnLiked: liked
    };

    if (id != null) {
      map[columnId] = id!;
    }
    return map;
  }

  void likeUnlike() {
    liked *= -1;
  }

  bool hasId() {
    return id != null;
  }
}
