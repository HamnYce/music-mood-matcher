import 'package:music_mood_matcher/models/recommendation/constants.dart';
import 'package:music_mood_matcher/screens/search/widgets/filter_buttons.dart';
import 'package:music_mood_matcher/utility/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin FilterableMixin {
  late Function(String) onFilterPressCallback;
  late FilterRadioButtons filterButtons;
  final String _filterPrefKey = '_filterCategoryIndex';
  String filterCategoryName = 'All';
  List<String> filters = ['All'] +
      categoryTypes.map((s) => basicPluralize(capitalize(s))).toList();

  void setOnPressFilterCallback({required Function(String) callback}) {}

  void loadFilterButtons() {
    filterButtons = FilterRadioButtons(
      onFilterPressCallback: onFilterPressCallback,
      filters: filters,
      filterPrefKey: _filterPrefKey,
    );
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      /// if we have a preference set from previous use then get and set that as our current state
      if (prefs.getInt(_filterPrefKey) != null) {
        filterCategoryName = filters[prefs.getInt(_filterPrefKey)!];
      }
    });
  }

  void filterButtonsInit({required Function(String n) onPressFilterCallback}) {
    onFilterPressCallback = onPressFilterCallback;
    loadFilterButtons();
    loadPreferences();
  }
}
