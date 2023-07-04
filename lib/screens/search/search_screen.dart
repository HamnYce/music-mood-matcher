import 'package:flutter/material.dart';
import 'package:music_mood_matcher/models/recommendation/constants.dart';
import 'package:music_mood_matcher/models/recommendation/recommendation.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_provider.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_tile.dart';
import 'package:music_mood_matcher/utility/filter_button_bar.dart';
import 'package:music_mood_matcher/screens/text_input/text_input_screen.dart';
import 'package:music_mood_matcher/utility/helper.dart';

// TODO: we can store the latest results as a JSON (if user favorites move them to the next screen)
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final RecommendationProvider _db = RecommendationProvider();
  bool _isData = false;
  List<Recommendation> _recs = [];
  String filterName = 'All';
  late final FilterButtonBar filterButtons = FilterButtonBar(
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

    _db.open(databaseName).then((value) {
      _db.getSearched().then(
        (searched) {
          setState(() {
            _recs = searched;
            _isData = true;
          });
        },
      );
    });
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
                      if (filterName == 'All' ||
                          normaliseCategory(filterName) == rec.category) {
                        recTiles.add(RecommendationTile(
                          rec: rec,
                          database: _db,
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
          onPressed: () async {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => const TextInputScreen()))
                .then((value) {
              setState(() {
                _db.getSearched().then(
                  (searched) {
                    setState(() {
                      _recs = searched;
                      _isData = true;
                    });
                  },
                );
              });
            });
          },
          child: const Icon(Icons.search),
        ),
      )
    ]);
  }
}
