import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'app.dart';

void main() async {
  // Force flutter to get ready for Database
  WidgetsFlutterBinding.ensureInitialized();

  // Start Hive in that platform
  await Hive.initFlutter();

  // Open box of data store
  await Hive.openBox('mood_box');

  runApp(const ProviderScope(child: MoodTrackerApp()));
}
