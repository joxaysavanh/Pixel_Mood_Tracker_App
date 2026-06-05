import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import 'mood_provider.dart';
import 'widgets/mood_analytics_widget.dart';
import 'widgets/mood_pixel_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<int, DayRecord> projectData = ref.watch(moodProvider);
    final int selectedDay = ref.watch(selectedDayProvider);
    
    // ดึงข้อมูลของวันที่กำลังเลือกอยู่ปัจจุบันออกมาแสดงผล
    final DayRecord? currentRecord = projectData[selectedDay];

    // สร้าง Controller สำหรับคุมข้อความในช่องพิมพ์
    final TextEditingController noteController = TextEditingController(text: currentRecord?.note ?? '');
    // วางเคอร์เซอร์ให้อยู่ท้ายประโยคเสมอเวลาสลับวัน
    noteController.selection = TextSelection.fromPosition(TextPosition(offset: noteController.text.length));

    const int monthOffset = 5;
    const int daysInMonth = 31;

    // แปลงข้อมูลส่งต่อให้ Widget สถิติ (ดึงเฉพาะส่วนอารมณ์ออกมา)
    final Map<int, MoodType> analyticsMap = projectData.map((key, value) => MapEntry(key, value.mood));

    return Scaffold(
      backgroundColor: AppColors.backgroud,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          color: Colors.white,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Pixel Mood Tracker',
                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView( // 💡 ใช้ตัวนี้ช่วยกันหน้าจอล้นเวลาแป้นพิมพ์มือถือเด้งขึ้นมา
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'May 2026',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 20),

                  // แถวบอกชื่อวัน
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((dayName) {
                      return SizedBox(
                        width: 40,
                        child: Text(
                          dayName,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary.withOpacity(0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),

                  // ตารางพิกเซลอารมณ์ (ใช้ตาราง GridView ปกติกำหนดหดขนาดตามจริง)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: daysInMonth + monthOffset,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      if (index < monthOffset) return const SizedBox.shrink();
                      final int day = index - monthOffset + 1;
                      final DayRecord? record = projectData[day];
                      
                      return MoodPixelWidget(
                        day: day,
                        mood: record?.mood,
                      );
                    },
                  ),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 10),

                  // ข้อความเปลี่ยนตามวันที่เลือก
                  Text(
                    selectedDay == DateTime.now().day
                        ? "How's your day going?"
                        : "What happened on May $selectedDay?",
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 15),

                  // แผงปุ่มเลือกสีอารมณ์
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.backgroud.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: MoodType.values.map((mood) {
                        return GestureDetector(
                          onTap: () {
                            ref.read(moodProvider.notifier).updateMood(selectedDay, mood);
                          },
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppColors.getColorForMood(mood),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.getColorForMood(mood).withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 💡 โซนแทรกใหม่: กล่องข้อความบันทึกความบันเทิงใจสไตล์ Minimalist 
                  // จะเปิดให้พิมพ์ก็ต่อเมื่อวันนั้นเลือกสีอารมณ์ไปแล้วเท่านั้น
                  if (currentRecord != null)
                    TextField(
                      controller: noteController,
                      maxLines: 2, // ให้พิมพ์ยาวได้ 2 บรรทัดพอดีงาม
                      maxLength: 60, // จำกัดคำสั้นๆ คลีนๆ แบบ Micro-note ไม่ให้ยาวรกรุงรัง
                      decoration: InputDecoration(
                        hintText: 'Write a short note about today...',
                        hintStyle: TextStyle(color: AppColors.textPrimary.withOpacity(0.3), fontSize: 13),
                        filled: true,
                        fillColor: AppColors.backgroud.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        counterText: "", // ซ่อนตัวเลขบอกจำนวนคำด้านล่างเพื่อความสะอาด
                      ),
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      onChanged: (text) {
                        // สั่งเซฟข้อความลงฐานข้อมูลแบบพิมพ์ไปเซฟไปทันที (Auto Save)
                        ref.read(moodProvider.notifier).updateNote(selectedDay, text);
                      },
                    ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Monthly Overview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 15),
                  
                  // แสดงผลสถิติโดยดึงค่าจากตัวแปรตัวใหม่
                  MoodAnalyticsWidget(monthlyMoods: analyticsMap),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}