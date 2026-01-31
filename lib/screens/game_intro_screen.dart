import 'dart:async';
import 'package:flutter/material.dart';

class GameIntroScreen extends StatefulWidget {
  final VoidCallback onIntroCompleted;

  const GameIntroScreen({super.key, required this.onIntroCompleted});

  @override
  State<GameIntroScreen> createState() => _GameIntroScreenState();
}

class _GameIntroScreenState extends State<GameIntroScreen> {
  // 0 = Splash Image, 1 = School Logo
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() async {
    // 1. Show "Image 1" (Splash) for 3 seconds
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _currentStep = 0; // Switch to School Logo
    });

    // 2. Show "Image 2" (School Logo) for 3 seconds
    await Future.delayed(const Duration(seconds: 0));
    if (!mounted) return;

    // 3. Notify main that the sequence is done
    widget.onIntroCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white, // Change to Black if your images have dark backgrounds
        body: Center(
          // AnimatedSwitcher makes the transition between images fade smoothly
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: _buildCurrentContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentContent() {
    if (_currentStep == 0) {
      // Step 1: Game Splash Image
      return Image.asset(
        'assets/images/splash.png',
        key: const ValueKey(1), // Key is required for AnimatedSwitcher to detect change
        fit: BoxFit.contain,    // Ensures the full image is visible
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      // Step 2: School Logo
      // Make sure this file exists in your pubspec.yaml assets!
      return Image.asset(
        'images/school_logo.png',
        key: const ValueKey(2),
        fit: BoxFit.contain,
        width: 300, // Logos are usually smaller, adjust as needed
        height: 300,
      );
    }
  }
}