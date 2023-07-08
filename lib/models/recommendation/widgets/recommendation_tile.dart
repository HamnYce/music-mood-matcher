import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_provider.dart';
import 'package:music_mood_matcher/utility/helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecommendationTile extends StatefulWidget {
  final Recommendation rec;
  final RecommendationProvider database;
  final Function() favIconPressCallback;

  const RecommendationTile({
    super.key,
    required this.rec,
    required this.database,
    required this.favIconPressCallback,
  });

  @override
  State<StatefulWidget> createState() => _RecommendationTileState();
}

class _RecommendationTileState extends State<RecommendationTile> {
  Widget likedWidget() {
    return widget.rec.liked == 1
        ? const Icon(Icons.favorite)
        : const Icon(Icons.favorite_outline);
  }

  void _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      launchUrlString(url);
    } else {
      print("could not launch url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.rec.thumbnailURL != null
          ? CachedNetworkImage(
              imageUrl: widget.rec.thumbnailURL!,
              placeholder: (context, url) => const CircularProgressIndicator(),
            )
          : Image.asset('assets/images/no-thumbnail.png'),
      title: Text(widget.rec.title),
      subtitle: Text(capitalize(widget.rec.category)),
      trailing: IconButton(
        icon: likedWidget(),
        onPressed: () {
          widget.favIconPressCallback();
          setState(() {});
        },
      ),
      onTap: () {
        _launchUrl(widget.rec.recommendationURL);
      },
    );
  }
}
