import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pixel_mood_tracker/core/constants/app_colors.dart';

// โมเดลข้อมูลคู่สำหรับ 1 วัน
class DayRecord {
  final MoodType mood;
  final String note;

  DayRecord({required this.mood, required this.note});
}

// ตัวจัดการข้อมูลอารมณ์และโน้ตบันทึกรูปแบบคีย์ String (yyyy-MM-dd)
class MoodNotifier extends StateNotifier<Map<String, DayRecord>> {
  final _box = Hive.box('mood_box');

  MoodNotifier() : super({}) {
    _loadDataFromHive();
  }

  void _loadDataFromHive() {
    final Map<String, DayRecord> loadedData = {};
    for (var key in _box.keys) {
      if (key is String && key.startsWith('mood_')) {
        final String dateKey = key.replaceFirst('mood_', '');
        
        final String? moodName = _box.get('mood_$dateKey');
        final String note = _box.get('note_$dateKey') ?? '';

        if (moodName != null) {
          loadedData[dateKey] = DayRecord(
            mood: MoodType.values.byName(moodName),
            note: note,
          );
        }
      }
    }
    state = loadedData;
  }

  void updateMood(String dateKey, MoodType mood) {
    final currentNote = state[dateKey]?.note ?? '';
    _box.put('mood_$dateKey', mood.name);

    state = {...state, dateKey: DayRecord(mood: mood, note: currentNote)};
  }

  void updateNote(String dateKey, String note) {
    final currentMood = state[dateKey]?.mood;
    
    if (currentMood != null) {
      _box.put('note_$dateKey', note);
      state = {...state, dateKey: DayRecord(mood: currentMood, note: note)};
    }
  }
}

// จดทะเบียน Provider ใช้งานภาพรวม
final moodProvider = StateNotifierProvider<MoodNotifier, Map<String, DayRecord>>((ref) {
  return MoodNotifier();
});

// ตัวคุมสถานะ "เดือนและปี" ที่กำลังเปิดดูบนปฏิทิน
final currentCalendarMonthProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// ตัวคุมสถานะ "วันที่ผู้ใช้จิ้มเลือกอยู่" (เก็บเป็นรูปแบบ DateTime)
final selectedDateTimeProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// ตัวแจ้งสลับและเซฟบันทึกธีมพาสเทลลงความจำเครื่อง
class ThemeNotifier extends StateNotifier<AppThemeType> {
  final _box = Hive.box('mood_box');

  ThemeNotifier() : super(AppThemeType.cottonCandy) {
    final String? savedTheme = _box.get('app_theme');
    if (savedTheme != null) {
      state = AppThemeType.values.byName(savedTheme);
    }
  }

  void changeTheme(AppThemeType newTheme) {
    _box.put('app_theme', newTheme.name);
    state = newTheme;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeType>((ref) {
  return ThemeNotifier();
});