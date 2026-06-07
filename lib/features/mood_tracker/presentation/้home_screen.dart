import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import 'mood_provider.dart';
import 'widgets/mood_analytics_widget.dart';
import 'widgets/mood_pixel_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isThemeExpanded = false;
  late TextEditingController _noteController;
  
  // 💡 สร้างตัวแปรไว้จำ DateKey ล่าสุด เพื่อใช้ล็อกไม่ให้โน้ตไหลทับซ้อนกัน
  String _lastDateKey = '';

  final List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    
    // 💡 ลอจิกใหม่: สั่ง Auto-save ผ่าน Listener ของ Controller โดยตรง 
    // ตัวหนังสือจะไม่เด้ง ไม่รวน และเคอร์เซอร์พิมพ์จะกระพริบทำงานได้อย่างต่อเนื่อง
    _noteController.addListener(() {
      final selectedDateTime = ref.read(selectedDateTimeProvider);
      final String dateKey = "${selectedDateTime.year}-${selectedDateTime.month}-${selectedDateTime.day}";
      
      // สั่งเซฟลงฐานข้อมูลเฉพาะตอนที่ผู้ใช้กำลังพิมพ์ข้อความจริงในวันนั้นๆ เท่านั้น
      if (_lastDateKey == dateKey && FocusScope.of(context).hasFocus) {
        ref.read(moodProvider.notifier).updateNote(dateKey, _noteController.text);
      }
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _makeDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, DayRecord> projectData = ref.watch(moodProvider);
    final DateTime currentCalendarMonth = ref.watch(currentCalendarMonthProvider);
    final DateTime selectedDateTime = ref.watch(selectedDateTimeProvider);
    final AppThemeType currentTheme = ref.watch(themeProvider);

    final String selectedDateKey = _makeDateKey(selectedDateTime);
    final DayRecord? currentRecord = projectData[selectedDateKey];

    // 💡 ลorิกการสลับสับเปลี่ยนวัน: ถ้ากดเปลี่ยนวัน ให้ดึงข้อความใหม่มาใส่กล่อง และย้ายโฟกัสเคอร์เซอร์ไปต่อท้ายสุดอัตโนมัติ
    if (_lastDateKey != selectedDateKey) {
      _lastDateKey = selectedDateKey;
      final String targetNote = currentRecord?.note ?? '';
      
      // อัปเดตข้อความในกล่องพิมพ์ให้ตรงวันแบบนิ่งๆ
      if (_noteController.text != targetNote) {
        _noteController.text = targetNote;
        _noteController.selection = TextSelection.fromPosition(
          TextPosition(offset: _noteController.text.length),
        );
      }
    }

    final int firstDayOfWeek = DateTime(currentCalendarMonth.year, currentCalendarMonth.month, 1).weekday;
    final int monthOffset = firstDayOfWeek == 7 ? 0 : firstDayOfWeek;
    final int daysInMonth = DateTime(currentCalendarMonth.year, currentCalendarMonth.month + 1, 0).day;

    final Map<int, MoodType> analyticsMap = {};
    projectData.forEach((dateKey, record) {
      final List<String> parts = dateKey.split('-');
      if (parts.length == 3) {
        final int year = int.parse(parts[0]);
        final int month = int.parse(parts[1]);
        final int day = int.parse(parts[2]);
        if (year == currentCalendarMonth.year && month == currentCalendarMonth.month) {
          analyticsMap[day] = record.mood;
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
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
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // แผงเมนูสลับธีมพาสเทล
                  Row(
                    children: [
                      const Text(
                        'Theme Palette',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black26, letterSpacing: 0.5),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          _isThemeExpanded ? Icons.expand_less : Icons.palette_outlined,
                          size: 18,
                          color: Colors.black26,
                        ),
                        onPressed: () => setState(() => _isThemeExpanded = !_isThemeExpanded),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: _isThemeExpanded
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: AppThemeType.values.map((themeType) {
                                final bool isThemeSelected = currentTheme == themeType;
                                final Color themeColor = AppColors.themePalettes[themeType]![MoodType.joyful]!;

                                return GestureDetector(
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    ref.read(themeProvider.notifier).changeTheme(themeType);
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: isThemeSelected ? Border.all(color: AppColors.textPrimary, width: 1.5) : null,
                                    ),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 10),
                  
                  // แถบสลับเดือนย้อนหลัง-ไปข้างหน้า
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_monthNames[currentCalendarMonth.month - 1]} ${currentCalendarMonth.year}",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              ref.read(currentCalendarMonthProvider.notifier).state = 
                                  DateTime(currentCalendarMonth.year, currentCalendarMonth.month - 1);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              ref.read(currentCalendarMonthProvider.notifier).state = 
                                  DateTime(currentCalendarMonth.year, currentCalendarMonth.month + 1);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // แถวชื่อวันสัปดาห์
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((dayName) {
                      return SizedBox(
                        width: 45,
                        child: Text(
                          dayName,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary.withOpacity(0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),

                  // ตารางปฏิทินกลมพาสเทล คำนวณวันอัจฉริยะ
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
                      
                      final DateTime pixelDate = DateTime(currentCalendarMonth.year, currentCalendarMonth.month, day);
                      final String pixelKey = _makeDateKey(pixelDate);
                      final DayRecord? record = projectData[pixelKey];

                      return MoodPixelWidget(date: pixelDate, mood: record?.mood);
                    },
                  ),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 10),

                  // ข้อความคำถามเปลี่ยนยืดหยุ่นตามวันและเดือนจริง
                  Text(
                    selectedDateTime.year == DateTime.now().year &&
                            selectedDateTime.month == DateTime.now().month &&
                            selectedDateTime.day == DateTime.now().day
                        ? "How's your day going?"
                        : "What happened on ${_monthNames[selectedDateTime.month - 1]} ${selectedDateTime.day}, ${selectedDateTime.year}?",
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 15),

                  // แผงปุ่มวงกลมสีอารมณ์พร้อมชื่ออังกฤษกำกับ
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: MoodType.values.map((mood) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ref.read(moodProvider.notifier).updateMood(selectedDateKey, mood);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedScale(
                                  scale: currentRecord?.mood == mood ? 1.18 : 1.0,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOutBack,
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: AppColors.getColorForMood(mood, currentTheme),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.getColorForMood(mood, currentTheme).withOpacity(0.35),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  mood.name[0].toUpperCase() + mood.name.substring(1),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary.withOpacity(
                                      currentRecord?.mood == mood ? 0.8 : 0.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 💡 ช่องพิมพ์โน้ตอัจฉริยะ: ลบคำสั่ง onChanged ทิ้งไป แล้วให้ระบบรันผ่านลอจิกคุมเงียบๆ ด้านบนแทน
                  if (currentRecord != null)
                    TextField(
                      controller: _noteController,
                      maxLines: 2,
                      maxLength: 100,
                      decoration: InputDecoration(
                        hintText: 'Write a short note about today...',
                        hintStyle: TextStyle(color: AppColors.textPrimary.withOpacity(0.3), fontSize: 13),
                        filled: true,
                        fillColor: AppColors.background.withOpacity(0.5),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        counterText: "",
                      ),
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                    ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Monthly Overview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 15),

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