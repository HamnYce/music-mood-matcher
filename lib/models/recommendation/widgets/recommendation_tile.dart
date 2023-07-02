import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_mood_matcher/models/recommendation/constants.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_provider.dart';
import 'package:music_mood_matcher/utility/helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

// FIXME: will break under search screen favoriting at the moment

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
  @override
  void initState() {
    super.initState();
    widget.database.open(databaseName);
  }

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
      leading: CachedNetworkImage(
        imageUrl: widget.rec.thumbnailURL,
        placeholder: (context, url) => const CircularProgressIndicator(),
      ),
      title: Text(widget.rec.title),
      subtitle: Text(capitalize(widget.rec.category)),
      trailing: IconButton(
        icon: likedWidget(),
        onPressed: () {
          setState(() {
            widget.rec.likeUnlike();
            if (widget.rec.hasId()) {
              widget.database.update(widget.rec);
            } else {
              // TODO: implement this
              throw "implement FAVICONCLICK in SEARCH SCREEN";
            }
            widget.favIconPressCallback();
          });
        },
      ),
      onTap: () {
        _launchUrl(widget.rec.recommendationURL);
      },
    );
  }
}
