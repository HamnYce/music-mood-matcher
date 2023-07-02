import 'package:flutter/material.dart';
import 'package:music_mood_matcher/models/recommendation/constants.dart';
import 'package:music_mood_matcher/models/recommendation/widgets/recommendation_provider.dart';
import 'package:music_mood_matcher/screens/favorites/favorites_screen.dart';
import 'package:music_mood_matcher/screens/search/search_screen.dart';
import 'package:sqflite/sqflite.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageStorageBucket _bucket = PageStorageBucket();

  static const List _screenOptions = <Widget>[
    SearchScreen(
      key: PageStorageKey<String>("searchScreen"),
    ),
    FavoritesScreen(
      key: PageStorageKey<String>("favoritesScreen"),
    ),
  ];
  static const List _screenTitles = <String>["Search", "Favorites"];

  void _bottomNavigationTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO: make this prettier
        title: Text(_screenTitles.elementAt(_currentIndex)),
      ),
      body: PageStorage(
          bucket: _bucket, child: _screenOptions.elementAt(_currentIndex)),
      // body: TextButton(
      //   child: Text('reset nigga'),
      //   onPressed: () {
      //     deleteDatabase(databaseName);
      //     var db = RecommendationProvider();
      //     db.open(databaseName).then((value) {
      //       db.seed();
      //       print("seeded");
      //     });
      //   },
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: _screenTitles.elementAt(0),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: _screenTitles.elementAt(1),
          ),
        ],
        onTap: _bottomNavigationTapped,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
