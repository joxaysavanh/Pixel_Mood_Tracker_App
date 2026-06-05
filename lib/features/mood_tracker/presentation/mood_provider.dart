import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pixel_mood_tracker/core/constants/app_colors.dart';

class DayRecord {
  final MoodType mood;
  final String note;

  DayRecord({required this.mood, required this.note});
}

// StateNotifier, Define State is Map<int, Moodtype> (key is day, value is mood)
class MoodNotifier extends StateNotifier<Map<int, DayRecord>> {
  // use Hive box
  final _box = Hive.box('mood_box');

  // When create MoodNotifier, go to download the old data immediately
  MoodNotifier() : super({}) {
    _loadDataFromHive();
  }

  // Load old data from database function
  void _loadDataFromHive() {
    final Map<int, DayRecord> loadedData = {};
    for (var key in _box.keys) {
      if (key is int) {
        // Hive จะเก็บข้อมูลแยกกัน: 'mood_4' เก็บสี, 'note_4' เก็บบันทึก
        final String? moodName = _box.get('mood_$key');
        final String note = _box.get('note_$key') ?? '';

        if (moodName != null) {
          loadedData[key] = DayRecord(
            mood: MoodType.values.byName(moodName),
            note: note,
          );
        }
      }
    }
    state = loadedData;
  }

  void updateMood(int day, MoodType mood) {
    final currentNote = state[day]?.note ?? '';
    _box.put('mood_$day', mood.name);

    state = {...state, day: DayRecord(mood: mood, note: currentNote)};
  }

  void updateNote(int day, String note) {
    final currentMood = state[day]?.mood;
    _box.put('note_$day', note);

    if (currentMood != null) {
      state = {...state, day: DayRecord(mood: currentMood, note: note)};
    }
  }
}

// Declear Provider valiable for useable in whole app
final moodProvider = StateNotifierProvider<MoodNotifier, Map<int, DayRecord>>((
  ref,
) {
  return MoodNotifier();
});

final selectedDayProvider = StateProvider<int>((ref) {
  return DateTime.now().day;
});
