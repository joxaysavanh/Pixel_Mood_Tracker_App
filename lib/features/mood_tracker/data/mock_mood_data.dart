import 'package:pixel_mood_tracker/core/constants/app_colors.dart';

class MockMoodData {
  // บันทึกข้อมูลจำลองเป็น Map โดยให้ Key เป็น "วันที่" และ Value เป็น "ประเภทอารมณ์"
  static final Map<int, MoodType> monthlyMoods = {
    1: MoodType.joyful, // วันที่ 1 มีความสุขมาก (สีเขียว)
    2: MoodType.peaceful, // วันที่ 2 สงบสบาย (สีฟ้า)
    3: MoodType.neutral, // วันที่ 3 เฉยๆ (สีเหลือง)
    4: MoodType.gloomy, // วันที่ 4 เศร้าๆ (สีเทา)
    5: MoodType.anxious, // วันที่ 5 กังวล (สีส้ม)
    // วันที่อื่นๆ ที่ยังไม่ได้บันทึก จะปล่อยให้เป็นช่องว่างสีเทาอ่อน
  };
}
