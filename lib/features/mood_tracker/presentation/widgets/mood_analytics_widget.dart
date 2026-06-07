import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixel_mood_tracker/core/constants/app_colors.dart';
import 'package:pixel_mood_tracker/features/mood_tracker/presentation/mood_provider.dart';

class MoodAnalyticsWidget extends ConsumerWidget {
  final Map<int, MoodType> monthlyMoods;

  const MoodAnalyticsWidget({super.key, required this.monthlyMoods});

  @override
  Widget build(BuildContext contex, WidgetRef ref) {
    final AppThemeType currentTheme = ref.watch(themeProvider);

    // check that the user has save any color mood on this month
    if (monthlyMoods.isEmpty) {
      return Text(
        'No data recorded for this month yet.',
        style: TextStyle(color: AppColors.textPrimary.withOpacity(0.5)),
      );
    }

    // Count date for each mood
    final Map<MoodType, int> moodCounts = {};
    for (var mood in monthlyMoods.values) {
      moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
    }

    final int totalRecordedDays = monthlyMoods.length;

    return Column(
      children:
          MoodType.values.map((mood) {
            final int count = moodCounts[mood] ?? 0;
            final double percentage =
                count / totalRecordedDays > 0
                    ? (count / totalRecordedDays)
                    : 0.0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Column(
                // Show name mood and date count
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mood.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${(percentage * 100).toStringAsFixed(0)}% ($count days)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Minimal progess bar
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      // Flexible color tab
                      FractionallySizedBox(
                        widthFactor: percentage, // 0.0 - 1.0
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.getColorForMood(mood, currentTheme).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
