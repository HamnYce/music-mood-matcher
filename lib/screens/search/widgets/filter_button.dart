import 'package:flutter/material.dart';

class FilterRadioButton extends StatefulWidget {
  final Function(int) onButtonPress;
  final int index;
  final String name;
  final AnimationController controller;

  const FilterRadioButton(
      {super.key,
      required this.onButtonPress,
      required this.index,
      required this.controller,
      required this.name});

  @override
  State<FilterRadioButton> createState() => _FilterRadioButtonState();
}

class _FilterRadioButtonState extends State<FilterRadioButton>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animation =
      ColorTween(begin: Colors.white, end: Colors.black)
          .animate(widget.controller);

  @override
  void initState() {
    super.initState();

    animation.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.onButtonPress(widget.index),
      style: ElevatedButton.styleFrom(backgroundColor: animation.value),
      child: Text(widget.name),
    );
  }
}
