import 'package:flutter/material.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_provider.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_tile.dart';
import 'package:music_mood_matcher/utility/helper.dart';
import 'package:music_mood_matcher/utility/mixins/filterable.dart';

// TODO: add confirmation dialog to remove something from the favorites to avoid
// TODO: any accidental deletion (since its not recoverable <- say that in the thingy!!)

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with FilterableMixin {
  List<Recommendation> favorites = [];
  final RecommendationProvider _db = RecommendationProvider();
  bool _loadedFavorites = false;

  @override
  void initState() {
    super.initState();
    filterButtonsInit(onPressFilterCallback: (name) {
      setState(() {
        filterCategoryName = name;
      });
    });

    _db.open('recommendation_db').then((value) {
      _db.getFavorites().then(
        (favs) {
          setState(() {
            favorites = favs;
            _loadedFavorites = true;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 50,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),

            /// Callback to effect parent widget (this) filtering properties
            child: filterButtons),
      ),
      _loadedFavorites
          ? Expanded(
              child: ListView(
                children: [
                  ...() {
                    List<RecommendationTile> recTiles = [];
                    for (Recommendation rec in favorites) {
                      if (filterCategoryName == 'All' ||
                          normaliseCategory(filterCategoryName) ==
                              rec.category) {
                        recTiles.add(RecommendationTile(
                          rec: rec,
                          database: _db,
                          favIconPressCallback: () => setState(() {
                            _db.getFavorites().then(
                                  (favs) => favorites = favs,
                                );
                          }),
                        ));
                      }
                    }
                    return recTiles;
                  }(),
                ],
              ),
            )
          : const Expanded(
              child: Center(
              child: CircularProgressIndicator(),
            ))
    ]);
  }
}
