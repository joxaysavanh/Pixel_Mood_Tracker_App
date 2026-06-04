import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixel_mood_tracker/core/constants/app_colors.dart';

// StateNotifier, Define State is Map<int, Moodtype> (key is day, value is mood)
class MoodNotifier extends StateNotifier<Map<int, MoodType>> {
  MoodNotifier() : super({});

  // Update mood of each day function
  void updateMood(int day, MoodType mood) {
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
