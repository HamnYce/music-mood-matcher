import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:music_mood_matcher/screens/main/main_screen.dart';

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
      theme: FlexThemeData.light(scheme: FlexScheme.purpleM3),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.deepPurple),
      home: const MainScreen(),
    );
  }
}
