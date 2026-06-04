import 'package:flutter/material.dart';
import 'package:pixel_mood_tracker/core/constants/app_colors.dart';
import 'package:pixel_mood_tracker/features/mood_tracker/data/mock_mood_data.dart';
import 'package:pixel_mood_tracker/features/mood_tracker/presentation/widgets/mood_pixel_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        final day = index + 1;
                        final MoodType? dayMood = MockMoodData.monthlyMoods[day];
                    
                        return MoodPixelWidget(
                          day: day,
                          mood: dayMood,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
