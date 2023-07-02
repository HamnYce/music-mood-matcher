import 'package:flutter/material.dart';
import 'package:music_mood_matcher/models/recommendation/constants.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_provider.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_tile.dart';
import 'package:music_mood_matcher/utility/filter_button_bar.dart';
import 'package:music_mood_matcher/utility/helper.dart';

// TODO: add confirmation dialog to remove something from the favorites to avoid
// TODO: any accidental deletion (since its not recoverable <- say that in the thingy!!)

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Recommendation> favorites = [];
  final RecommendationProvider _db = RecommendationProvider();
  bool _loadedFavorites = false;
  String filterName = 'All';
  late final FilterRadioButtons filterButtons = FilterRadioButtons(
      onFilterPressCallback: (name) {
        setState(() {
          filterName = name;
        });
      },
      filters_: categoryTypes,
      filterPrefKey: 'filter');

  @override
  void initState() {
    super.initState();

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
                      if (filterName == 'All' ||
                          normaliseCategory(filterName) == rec.category) {
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
