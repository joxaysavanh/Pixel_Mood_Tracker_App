import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixel_mood_tracker/core/constants/app_colors.dart';
import 'features/mood_tracker/presentation/mood_provider.dart';
import 'package:pixel_mood_tracker/features/mood_tracker/presentation/%E0%B9%89home_screen.dart';

class MoodTrackerApp extends ConsumerWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppThemeType currentTheme = ref.watch(themeProvider);
    final Color primaryAppColor =
        AppColors.themePalettes[currentTheme]![MoodType.joyful]!;

    return MaterialApp(
      title: "pixel Mood Tracker",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryAppColor,
          background: AppColors.background,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
