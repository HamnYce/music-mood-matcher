import 'package:flutter/material.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_provider.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_tile.dart';
import 'package:music_mood_matcher/screens/search/widgets/json_to_recommendations.dart';
import 'package:music_mood_matcher/screens/text_input/text_input_screen.dart';
import 'package:music_mood_matcher/utility/helper.dart';
import 'package:music_mood_matcher/utility/mixins/filterable.dart';

// TODO: we can store the latest results as a JSON (if user favorites move them to the next screen)
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with FilterableMixin {
  bool _isData = false;
  List<Recommendation> _recs = [];
  @override
  void initState() {
    super.initState();

    filterButtonsInit(
        onPressFilterCallback: (name) => setState(() {
              filterCategoryName = name;
            }));

    /// Parse the json file and set the recommendations to the newly ripped tracks
    JSONtoRecommendations(
      finishedData: () {
        setState(() {
          _isData = true;
        });
      },
      setRecs: (newRecs) {
        setState(() {
          _recs = newRecs;
        });
      },
    );
  }

  //add a floating action button and when the user submits it runs _createRecommendation
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          SizedBox(
            height: 50,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),

                /// Callback to effect parent widget (this) filtering properties
                child: filterButtons),
          ),
          _isData
              ? Expanded(
                  child: ListView(children: [
                  ...() {
                    List<RecommendationTile> recTiles = [];
                    for (Recommendation rec in _recs) {
                      if (filterCategoryName == 'All' ||
                          normaliseCategory(filterCategoryName) ==
                              rec.category) {
                        recTiles.add(RecommendationTile(
                          rec: rec,
                          database: RecommendationProvider(),
                          favIconPressCallback: () {
                            setState(() {});
                          },
                        ));
                      }
                    }
                    return recTiles;
                  }()
                ]))
              : const Expanded(
                  child: Center(child: CircularProgressIndicator()))
        ],
      ),
      Positioned(
        bottom: 10,
        right: 20,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TextInputScreen()));
          },
          child: const Icon(Icons.search),
        ),
      )
    ]);
  }
}
