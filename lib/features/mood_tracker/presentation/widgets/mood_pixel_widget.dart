import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixel_mood_tracker/features/mood_tracker/presentation/mood_provider.dart';
import '../../../../core/constants/app_colors.dart';

class MoodPixelWidget extends ConsumerWidget {
  final int day;
  final MoodType? mood;

  const MoodPixelWidget({super.key, required this.day, this.mood});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedDay = ref.watch(selectedDayProvider);
    final bool isSelected = selectedDay == day;

    final Color pixelColor =
        mood != null ? AppColors.getColorForMood(mood!) : const Color(0xFFF0F2F5);

    return GestureDetector(
      onTap: () {
        ref.read(selectedDayProvider.notifier).state = day;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: isSelected ? const EdgeInsets.all(0) : const EdgeInsets.all(2),

        decoration: BoxDecoration(
          color: pixelColor,
          shape: BoxShape.circle,
          border:
              isSelected
                  ? Border.all(color: Colors.black26, width: 2.0)
                  : null,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              color:
                  mood != null
                      ? Colors.white
                      : Colors.black26,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
