import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SantBaniApp());
}

class SantBaniApp extends StatelessWidget {
  const SantBaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sant Bani Searcher',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xffFAF7F2),
      ),

      home: const HomeScreen(),
    );
  }
}