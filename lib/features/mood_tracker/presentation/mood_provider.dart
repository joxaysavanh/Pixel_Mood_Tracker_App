import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pixel_mood_tracker/core/constants/app_colors.dart';

// StateNotifier, Define State is Map<int, Moodtype> (key is day, value is mood)
class MoodNotifier extends StateNotifier<Map<int, MoodType>> {
  // use Hive box
  final _box = Hive.box('mood_box');

  // When create MoodNotifier, go to download the old data immediately
  MoodNotifier() : super({}) {
    _loadMoodsFromDatabase();
  }

  // Load old data from database function
  void _loadMoodsFromDatabase() {
    final Map<int, MoodType> loadedMoods = {};
    for (var key in _box.keys) {
      if (key is int) {
        final String? moodName = _box.get(key);
        if (moodName != null) {
          loadedMoods[key] = MoodType.values.byName(moodName);
        }
      }
    }
    state = loadedMoods;
  }

  void updateMood(int day, MoodType mood) {
    _box.put(day, mood.name);
    state = {...state, day: mood};
  }
}

// Declear Provider valiable for useable in whole app
final moodProvider = StateNotifierProvider<MoodNotifier, Map<int, MoodType>>((
  ref,
) {
  return MoodNotifier();
});

final selectedDayProvider = StateProvider<int>((ref) {
  return DateTime.now().day;
});
