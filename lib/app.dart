import 'package:flutter/material.dart';
import 'package:pixel_mood_tracker/core/constants/app_colors.dart';
import 'package:pixel_mood_tracker/features/mood_tracker/presentation/%E0%B9%89home_screen.dart';

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "pixel Mood Tracker",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroud,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.moodJoyful,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}