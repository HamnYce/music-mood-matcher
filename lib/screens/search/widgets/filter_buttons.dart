import 'package:flutter/material.dart';
import 'package:music_mood_matcher/utility/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

/// Filter radio buttons that uses sharepreferences to store the currently selected index
/// to stay synchronised with its parent component
class FilterRadioButtons extends StatefulWidget {
  final void Function(String) onFilterPressCallback;
  late List<String> filters;
  final String filterPrefKey;

  FilterRadioButtons(
      {super.key,
      required this.onFilterPressCallback,
      required this.filters,
      required this.filterPrefKey}) {
    filters = ['All'] +
        filters.map<String>((s) => basicPluralize(capitalize(s))).toList();
  }

  @override
  State<FilterRadioButtons> createState() => _FilterRadioButtonsState();
}

class _FilterRadioButtonsState extends State<FilterRadioButtons>
    with TickerProviderStateMixin {
  int _filterCategoryIndex = 0;

  late final List<AnimationController> _controllers = List.generate(
    widget.filters.length,
    (index) => AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    ),
  );

  late List<FilterRadioButton> buttons =
      List.generate(widget.filters.length, (index) {
    return FilterRadioButton(
        onButtonPress: (index) {
          setState(() {
            _filterCategoryIndex = index;
            updateSelection();
            updateAnimation();
            _saveCategoryFilterPrefs();
          });
        },
        controller: _controllers[index],
        index: index,
        name: widget.filters[index]);
  });

  void updateSelection() {
    widget.onFilterPressCallback(widget.filters[_filterCategoryIndex]);
  }

  void updateAnimation() {
    for (int i = 0; i < _controllers.length; i++) {
      if (i == _filterCategoryIndex) {
        _controllers[i].forward();
      } else {
        _controllers[i].reverse();
      }
    }
  }

  void _saveCategoryFilterPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(widget.filterPrefKey, _filterCategoryIndex);
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getInt(widget.filterPrefKey) != null) {
        _filterCategoryIndex = prefs.getInt(widget.filterPrefKey)!;
      }
      _controllers[_filterCategoryIndex].forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 5),
        itemBuilder: (context, index) {
          return buttons[index];
        },
        separatorBuilder: (context, index) => const SizedBox(
              width: 8,
            ),
        itemCount: widget.filters.length);
  }
}
