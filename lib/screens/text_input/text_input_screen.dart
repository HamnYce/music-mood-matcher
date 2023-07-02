// TODO: implement this
// TODO:  you could maybe add a search history function but meh, its not part of the requirements

// TODO: need a search bar at the top of the screen
// TODO:  on hitting enter it takes the user back to the search screen
// TODO:  search screen should be loading
// TODO:  once it finishes loading it should display the appropriate results (musics and stuff)
// TODO:  create a submit button

// use fade out animation when popping off the navigation stack

import 'package:flutter/material.dart';

class TextInputScreen extends StatefulWidget {
  const TextInputScreen({super.key});

  @override
  State<TextInputScreen> createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextField(
          decoration: const InputDecoration(hintText: "hello world"),
          onSubmitted: (value) {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
