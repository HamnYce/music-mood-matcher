import 'package:flutter/material.dart';
import 'package:music_mood_matcher/utility/api/huggingface/roberta_emotion_analysis.dart';
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
  final RobertaGoEmotionsApi robertaEmotionApi = RobertaGoEmotionsApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextField(
          maxLength: _maxLength,
          decoration: const InputDecoration(hintText: _hintText),
          onSubmitted: (userInput) {
            // print(value);
            robertaEmotionApi.query(userInput).then((top3Emotions) {
              spotify.search(top3Emotions).then((value) {
                Navigator.of(context).pop();
              });
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
