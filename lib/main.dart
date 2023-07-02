import 'package:flutter/material.dart';
import 'package:music_mood_matcher/screens/main/main_screen.dart';
// TODO: create app launcher

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
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          colorSchemeSeed: Colors.purple,
          useMaterial3: true,
        ),
        home: const MainScreen());
  }
}
