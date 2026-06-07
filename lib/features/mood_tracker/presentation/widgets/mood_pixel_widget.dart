import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../mood_provider.dart';

class MoodPixelWidget extends ConsumerWidget {
  final DateTime date;
  final MoodType? mood;

  const MoodPixelWidget({
    super.key,
    required this.date,
    this.mood,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime selectedDateTime = ref.watch(selectedDateTimeProvider);
    final AppThemeType currentTheme = ref.watch(themeProvider);
    
    // ไฮไลท์เส้นขอบถ้าระบุ ปี เดือน วัน ตรงกันเป๊ะๆ
    final bool isSelected = selectedDateTime.year == date.year &&
        selectedDateTime.month == date.month &&
        selectedDateTime.day == date.day;

    final Color pixelColor = mood != null 
        ? AppColors.getColorForMood(mood!, currentTheme) 
        : const Color(0xFFF0F2F5); // เทาพาสเทลอ่อนจาง สบายตาสำหรับวันว่างเปล่า

    return GestureDetector(
      onTap: () {
        ref.read(selectedDateTimeProvider.notifier).state = date;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: isSelected ? const EdgeInsets.all(0) : const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: pixelColor,
          shape: BoxShape.circle, // รูปทรงวงกลม Aesthetic อ่อนโยน
          border: isSelected 
              ? Border.all(color: Colors.black26, width: 2.0)
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: mood != null ? Colors.white : Colors.black26,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}