import 'package:flutter/material.dart';
import 'package:music_mood_matcher/models/recommendation/constants.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_provider.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_tile.dart';
import 'package:music_mood_matcher/screens/search/widgets/filter_buttons.dart';
import 'package:music_mood_matcher/screens/search/widgets/json_to_recommendations.dart';
import 'package:music_mood_matcher/screens/text_input/text_input_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_mood_matcher/utility/helper.dart';

// TODO: we can store the latest results as a JSON (if user favorites move them to the next screen)
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isData = false;
  List<Recommendation> _recs = [];
  late FilterRadioButtons _filterButtons = _filterButtons = FilterRadioButtons(
    setFilterNameCallback: (name) => setState(() {
      _filterCategoryName = name;
    }),
    filters: filters,
    filterPrefKey: _filterPrefKey,
  );
  final String _filterPrefKey = '_filterCategoryIndex';
  String _filterCategoryName = 'All';
  List<String> filters = ['All'] +
      categoryTypes.map((s) => basicPluralize(capitalize(s))).toList();

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      /// if we have a preference set from previous use then get and set that as our current state
      if (prefs.getInt(_filterPrefKey) != null) {
        _filterCategoryName = filters[prefs.getInt(_filterPrefKey)!];
      }
    });

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
                child: _filterButtons),
          ),
          _isData
              ? Expanded(
                  child: ListView(children: [
                  ...() {
                    List<RecommendationTile> recTiles = [];
                    for (Recommendation rec in _recs) {
                      if (_filterCategoryName == 'All' ||
                          normaliseCategory(_filterCategoryName) ==
                              rec.category) {
                        recTiles.add(RecommendationTile(
                          rec: rec,
                          database: RecommendationProvider(),
                          favIconPressCallback: () {},
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
