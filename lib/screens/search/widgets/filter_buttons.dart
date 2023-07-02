import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Filter radio buttons that uses sharepreferences to store the currently selected index
/// to stay synchronised with its parent component
class FilterRadioButtons extends StatefulWidget {
  final void Function(String) onFilterPressCallback;
  final List<String> filters;
  final String filterPrefKey;

  const FilterRadioButtons(
      {super.key,
      required this.onFilterPressCallback,
      required this.filters,
      required this.filterPrefKey});

  @override
  State<FilterRadioButtons> createState() => _FilterRadioButtonsState();
}

class _FilterRadioButtonsState extends State<FilterRadioButtons>
    with TickerProviderStateMixin {
  int _filterCategoryIndex = 0;
  final List<AnimationController> _controllers = [];
  final List<Animation<Color?>> _animations = [];

  void _saveCategoryFilterPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(widget.filterPrefKey, _filterCategoryIndex);
  }

  @override
  void initState() {
    super.initState();

    /// Initialise controllers and animations for each filter button
    for (int i = 0; i < widget.filters.length; i++) {
      _controllers.add(AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ));

      /// Let animation values lerp between colors not 0..1
      _animations.add(ColorTween(begin: Colors.white, end: Colors.black)
          .animate(_controllers[i]));

      /// select the index of the already chosen one

      /// let listener call setState to show the animation
      _animations[i].addListener(() => setState(() {}));
    }

    /// Loading the preferences if (any are saved)
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getInt(widget.filterPrefKey) != null) {
        _filterCategoryIndex = prefs.getInt(widget.filterPrefKey)!;
      }
      _controllers[_filterCategoryIndex].forward();
    });
  }

  void onButtonPress(int index) {
    setState(() {
      /// Calls the function inside the parent container (searchScreen)
      /// to see the values in search screen for filtering

      for (int i = 0; i < _controllers.length; i++) {
        /// if button is clicked make it selected color and the rest are deselected
        (i == index) ? _controllers[i].forward() : _controllers[i].reverse();
      }
      _filterCategoryIndex = index;
      _saveCategoryFilterPrefs();
      widget.onFilterPressCallback(widget.filters[index]);
    });
  }

  Widget filterButton(BuildContext context, int index) {
    return ElevatedButton(
      onPressed: () => onButtonPress(index),
      style:
          // TODO: when we're initialising here we need to set the one that is loaded to the end
          ElevatedButton.styleFrom(backgroundColor: _animations[index].value),
      child: Text(widget.filters[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 5),
        itemBuilder: filterButton,
        separatorBuilder: (context, index) => const SizedBox(
              width: 8,
            ),
        itemCount: 5);
  }

  @override
  void dispose() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].removeListener(() {});
    }
    super.dispose();
  }
}
