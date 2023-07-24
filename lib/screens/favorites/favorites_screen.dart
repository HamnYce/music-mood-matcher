import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_mood_matcher/models/recommendation/constants.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_provider.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_tile.dart';
import 'package:music_mood_matcher/utility/filter_button_bar.dart';
import 'package:music_mood_matcher/utility/helper.dart';

// TODO: add confirmation dialog to remove something from the favorites to avoid

void confirmationDialog(BuildContext context, Function update) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Please Confirm'),
          content: const Text(
              'Are you sure you want to unfavourite (You cannot undo this action)?'),
          actions: [
            // The "Yes" button
            CupertinoDialogAction(
              onPressed: () {
                update();
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
              isDestructiveAction: true,
              child: const Text('Yes'),
            ),
            // The "No" button
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: false,
              isDestructiveAction: false,
              child: const Text('No'),
            )
          ],
        );
      });
}

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Recommendation> _favorites = [];
  final RecommendationProvider _db = RecommendationProvider();
  bool _loadedFavorites = false;
  String _filterName = 'All';
  late final FilterButtonBar _filterButtons = FilterButtonBar(
      onFilterPressCallback: (name) {
        setState(() {
          _filterName = name;
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
            _favorites = favs;
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
            child: _filterButtons),
      ),
      _loadedFavorites
          ? Expanded(
              child: ListView(
                children: [
                  ...() {
                    List<RecommendationTile> recTiles = [];
                    for (Recommendation rec in _favorites) {
                      if (_filterName == 'All' ||
                          normaliseCategory(_filterName) == rec.category) {
                        recTiles.add(RecommendationTile(
                          rec: rec,
                          database: _db,
                          favIconPressCallback: () {
                            // show alert dialog to remove favorites
                            confirmationDialog(context, () {
                              setState(() {
                                rec.likeUnlike();
                                _db.update(rec).then((value) {
                                  setState(() {
                                    _db.getFavorites().then(
                                          (favs) => _favorites = favs,
                                        );
                                  });
                                });
                              });
                            });
                          },
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
