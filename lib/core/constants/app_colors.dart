import 'package:flutter/material.dart';

// Create Enum to manage the different mood types
enum MoodType { joyful, peaceful, neutral, anxious, gloomy }

// Create a class to manage the design tokens colors
class AppColors {
  static const Color backgroud = Color(0xFFF7F7F7);
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color moodJoyful = Color(0xFF4CAF50);
  static const Color moodPeaceful = Color(0xFF42A5F5);
  static const Color moodNeutral = Color(0xFFFFCA28);
  static const Color moodAnxious = Color(0xFFFF7043);
  static const Color moodGloomy = Color(0xFF78909C);

  // Method to get the color based on the mood type
  static Color getColorForMood(MoodType mood) {
    switch (mood) {
      case MoodType.joyful:
        return moodJoyful;
      case MoodType.peaceful:
        return moodPeaceful;
      case MoodType.neutral:
        return moodNeutral;
      case MoodType.anxious:
        return moodAnxious;
      case MoodType.gloomy:
        return moodGloomy;
    }
  }
}
