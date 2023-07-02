import 'package:music_mood_matcher/models/recommendation/recommendation.dart';

class RecommendationGroup {
  // TODO: Implement This, contains a list of recommendations (stored locally on users device)
  //  should be deletable.
  final List<Recommendation> recommendations;
  final String title; //(users input text capped at 30 chars)
  final List<String> thumbnailGroupImageUrls;

  const RecommendationGroup(
      {required this.recommendations,
      required this.title,
      required this.thumbnailGroupImageUrls});
}
