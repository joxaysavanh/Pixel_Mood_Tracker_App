import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class MoodPixelWidget extends StatelessWidget {
  final int day;
  final MoodType? mood;

  const MoodPixelWidget({super.key, required this.day, this.mood});

  @override
  Widget build(BuildContext context) {
    final Color pixelColor =
        mood != null ? AppColors.getColorForMood(mood!) : Colors.black12;
    return Container(
      decoration: BoxDecoration(
        color: pixelColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            color: mood != null ? Colors.white : AppColors.textPrimary.withOpacity(0.4),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
