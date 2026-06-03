import 'package:flutter/material.dart';
import 'package:pixel_mood_tracker/core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroud,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pixel Mood',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Text(
          'Here the pixel mood table',
          style: TextStyle(
            color: AppColors.textPrimary.withOpacity(0.5),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
