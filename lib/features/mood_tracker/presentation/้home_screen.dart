import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixel_mood_tracker/core/constants/app_colors.dart';
import 'package:pixel_mood_tracker/features/mood_tracker/data/mock_mood_data.dart';
import 'package:pixel_mood_tracker/features/mood_tracker/presentation/mood_provider.dart';
import 'package:pixel_mood_tracker/features/mood_tracker/presentation/widgets/mood_pixel_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<int, MoodType> monthlyMoods = ref.watch(moodProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroud,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 450),
          color: Colors.white,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(
                'Pixel Mood Tracker',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'May 2026',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: GridView.builder(
                      itemCount: 31,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemBuilder: (context, index) {
                        final day = index + 1;
                        final MoodType? dayMood = monthlyMoods[day];

                        return MoodPixelWidget(day: day, mood: dayMood);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Mood selector Panel
                  Text(
                    ref.watch(selectedDayProvider) == DateTime.now().day
                        ? 'How are you today? (Today)'
                        : 'How were you on May ${ref.watch(selectedDayProvider)}?',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Mood selector 5 colors
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        MoodType.values.map((mood) {
                          return GestureDetector(
                            onTap: () {
                              // Pull the selected date from Riverpod
                              final int targetDay = ref.read(
                                selectedDayProvider,
                              );
                              // Update mood to the day
                              ref
                                  .read(moodProvider.notifier)
                                  .updateMood(targetDay, mood);
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.getColorForMood(mood),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.getColorForMood(
                                      mood,
                                    ).withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
