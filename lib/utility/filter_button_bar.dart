import 'package:flutter/material.dart';
import 'package:music_mood_matcher/utility/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_mood_matcher/utility/filter_button.dart';

/// Filter radio buttons that uses sharepreferences to store the currently selected index
/// to stay synchronised with its parent component
class FilterButtonBar extends StatefulWidget {
  final void Function(String) _onFilterPressCallback;
  late final List<String> _filters;
  final String _filterPrefKey;

  FilterButtonBar(
      {super.key,
      required void Function(String) onFilterPressCallback,
      required filters_,
      required String filterPrefKey})
      : _filterPrefKey = filterPrefKey,
        _onFilterPressCallback = onFilterPressCallback {
    _filters = ['All'] +
        filters_.map<String>((s) => basicPluralize(capitalize(s))).toList();
  }

  @override
  State<FilterButtonBar> createState() => _FilterButtonBarState();
}

class _FilterButtonBarState extends State<FilterButtonBar>
    with TickerProviderStateMixin {
  int _filterCategoryIndex = 0;

  late final List<AnimationController> _controllers = List.generate(
    widget._filters.length,
    (index) => AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    ),
  );

  late final List<FilterRadioButton> _buttons =
      List.generate(widget._filters.length, (index) {
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
        name: widget._filters[index]);
  });

  void updateSelection() {
    widget._onFilterPressCallback(widget._filters[_filterCategoryIndex]);
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
    await prefs.setInt(widget._filterPrefKey, _filterCategoryIndex);
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getInt(widget._filterPrefKey) != null) {
        _filterCategoryIndex = prefs.getInt(widget._filterPrefKey)!;
      }

      updateSelection();
      updateAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 5),
        itemBuilder: (context, index) {
          return _buttons[index];
        },
        separatorBuilder: (context, index) => const SizedBox(
              width: 8,
            ),
        itemCount: widget._filters.length);
  }

  @override
  void dispose() {
    _controllers.map((con) => con.dispose()).toList();
    super.dispose();
  }
}
