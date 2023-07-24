import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class FilterRadioButton extends StatefulWidget {
  final Function(int) _onButtonPress;
  final int _index;
  final String name;
  final AnimationController _controller;

  const FilterRadioButton(
      {super.key,
      required dynamic Function(int) onButtonPress,
      required int index,
      required AnimationController controller,
      required this.name})
      : _onButtonPress = onButtonPress,
        _index = index,
        _controller = controller;

  @override
  State<FilterRadioButton> createState() => _FilterRadioButtonState();
}

class _FilterRadioButtonState extends State<FilterRadioButton>
    with SingleTickerProviderStateMixin {
  late final Animation<Color?> _colorAnimation =
      ColorTween(begin: Colors.black, end: Colors.white)
          .animate(widget._controller);

  @override
  void initState() {
    super.initState();

    _colorAnimation.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      onPressed: () => widget._onButtonPress(widget._index),
      child: Text(
        widget.name,
        style: TextStyle(color: _colorAnimation.value),
      ),
    );
  }
}
