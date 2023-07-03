import 'package:flutter/material.dart';
import 'package:music_mood_matcher/screens/main/main_screen.dart';

// TODO: clean and organise code
// TODO:  figure out how to refresh search page after new search
// TODO:  i figured it out!! use setstate to redeclare the searches (like in favorites_screen)!

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Music Mood Matcher',
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
          colorSchemeSeed: Colors.purple,
          useMaterial3: true,
        ),
        home: const MainScreen());
  }
}
