// TODO: implement this
// TODO:  you could maybe add a search history function but meh, its not part of the requirements

// TODO: this screen will contain the logic for ripping the request,
// TODO:  parsing and storing into sqlite and returning back to the main page

// TODO:

import 'package:flutter/material.dart';
import 'package:music_mood_matcher/utility/api/spotify/spotify_api.dart';

class TextInputScreen extends StatefulWidget {
  const TextInputScreen({super.key});

  @override
  State<TextInputScreen> createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  final int _maxLength = 50;
  static const String _hintText = 'What are you feeling right now?';
  final SpotifyApi spotify = SpotifyApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextField(
          maxLength: _maxLength,
          decoration: const InputDecoration(hintText: _hintText),
          onSubmitted: (value) {
            // print(value);
            spotify.search(value).then((value) {
              Navigator.of(context).pop();
            });
          },
          autofocus: true,
          buildCounter: (context,
                  {required currentLength,
                  required isFocused,
                  required maxLength}) =>
              Text('${maxLength! - currentLength}'),
        ),
      ),
    );
  }
}
