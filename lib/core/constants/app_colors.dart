import 'package:flutter/material.dart';

enum MoodType { joyful, peaceful, neutral, anxious, gloomy }

// 💡 สร้าง Enum สำหรับสลับ 5 ธีมมินิมอลตามความชอบของ User
enum AppThemeType {
  cottonCandy,  // 1. Cotton Candy (จากภาพเรฟเฟอเรนซ์)
  sageGreen,    // 2. Sage Green (โทนธรรมชาติ ผ่อนคลายสบายตา)
  lavenderMist, // 3. Lavender Mist (โทนม่วงละมุน ชวนฝัน)
  warmTerracotta,// 4. Warm Terracotta (โทนส้มอบอุ่น สบายใจ)
  oceanBreeze   // 5. Ocean Breeze (โทนฟ้าฟ้าน้ำทะเล ปลอดโปร่ง)
}

class AppColors {
  static const Color background = Color(0xFFFBFBFD); // ขาวสว่างนวลตา สไตล์มินิมอลระดับโลก
  static const Color textPrimary = Color(0xFF3A3A3C); // เทาเข้ม นุ่มนวลกว่าสีดำสนิท

  // 💡 คลังแผนผังสีพาสเทล 5 ธีมที่คัดเลือกมาอย่างดี ไม่ซ้ำแนวกัน
  static const Map<AppThemeType, Map<MoodType, Color>> themePalettes = {
    AppThemeType.cottonCandy: {
      MoodType.joyful: Color(0xFFE27888),   // ชมพูพาสเทลอมส้ม
      MoodType.peaceful: Color(0xFFCBADCC), // ม่วงพาสเทลละมุน
      MoodType.neutral: Color(0xFFF9D9E1),  // ชมพูนมใสๆ
      MoodType.anxious: Color(0xFFEC3957),  // ฟ้าเทาซอฟต์ๆ
      MoodType.gloomy: Color(0xFF6A4670),   // ฟ้าหม่นพรีเมียม
    },
    AppThemeType.sageGreen: {
      MoodType.joyful: Color(0xFF97B6E0),   // ฟ้าอ่อน
      MoodType.peaceful: Color(0xFF86B570), // เขียวเซจ
      MoodType.neutral: Color(0xFFCBD5C5),  // เขียวหม่นจางๆ
      MoodType.anxious: Color(0xFF968422),  // ครีมเบจ
      MoodType.gloomy: Color(0xFF3E622B),   // เขียวขี้เถ้าซอฟต์ๆ
    },
    AppThemeType.lavenderMist: {
      MoodType.joyful: Color(0xFFE07DF2),   // ม่วงสว่างพาสเทล
      MoodType.peaceful: Color(0xFFD2AFD8), // ม่วงลาเวนเดอร์
      MoodType.neutral: Color(0xFFF3E5F5),  // ม่วงขาวมินิมอล
      MoodType.anxious: Color(0xFF5A3C92),  // ม่วงครามซอฟต์ๆ
      MoodType.gloomy: Color(0xFF90A4AE),   // เทาฟ้าไอหมอก
    },
    AppThemeType.warmTerracotta: {
      MoodType.joyful: Color(0xFFF5C2B3),   // ส้มชานมพาสเทล
      MoodType.peaceful: Color(0xFFD4BFAC), // ครีมทรายอบอุ่น
      MoodType.neutral: Color(0xFFF9EBE0),  // นมวานิลลา
      MoodType.anxious: Color(0xFFDA8A6B),  // ส้มอิฐนุ่มๆ
      MoodType.gloomy: Color(0xFFB0A4A4),   // น้ำตาลเทาละมุน
    },
    AppThemeType.oceanBreeze: {
      MoodType.joyful: Color(0xFFB3E5FC),   // ฟ้าพาสเทลสว่าง
      MoodType.peaceful: Color(0xFF81D4FA), // ฟ้าสดใสอ่อนๆ
      MoodType.neutral: Color(0xFFE1F5FE),  // ฟ้าน้ำนมมินิมอล
      MoodType.anxious: Color(0xFF01ACFB),  // ฟ้าทะเลนุ่มตา
      MoodType.gloomy: Color(0xFF78909C),   // ฟ้าเทาฝนปนหมอก
    },
  };

  // 💡 ฟังก์ชันดึงสีตามธีมปัจจุบันที่เลือกอยู่
  static Color getColorForMood(MoodType mood, AppThemeType currentTheme) {
    return themePalettes[currentTheme]?[mood] ?? themePalettes[AppThemeType.cottonCandy]![mood]!;
  }
}