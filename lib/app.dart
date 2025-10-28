import 'package:dino_run/core/routes/routes.dart';
import 'package:dino_run/game/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class DinoRunApp extends StatefulWidget {
  const DinoRunApp({super.key});

  @override
  State<DinoRunApp> createState() => _DinoRunAppState();
}

class _DinoRunAppState extends State<DinoRunApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // 3. Register the observer
    WidgetsBinding.instance.addObserver(this);

    // Call your function to remove the splash
    initializeApp();
  }

  void initializeApp() async {
    // This is where you can load resources, check logins, etc.

    // --- THIS IS YOUR "DURATION" ---
    // Wait for 3 seconds (or any duration you want)
    await Future.delayed(const Duration(seconds: 3));

    // After the delay, remove the splash screen
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    // 4. Unregister the observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 5. Implement the lifecycle method
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // App is in the background
      print("App is paused (from MyApp). Stopping music.");
      AudioManager.instance.pauseBgm();
    } else if (state == AppLifecycleState.resumed) {
      // App is back in the foreground
      print("App is resumed (from MyApp).");

      // Example:
      AudioManager.instance.resumeBgm();
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    List<String> images = [
      'assets/images/backgrounds/character bg.png',
      'assets/images/backgrounds/wood texture 01.png',
      'assets/images/arrow - left.png',
      'assets/images/arrow - right.png',
      'assets/images/bg_square.png',
      'assets/images/paper_bg.png',
      'assets/images/background 2.png',
      'assets/images/item_box.png',
      'assets/images/back arrow.png',
      'assets/images/background 2.png',
      'assets/images/chapters.png',
      'assets/images/circle.png',
      'assets/images/Completed Menu.png',
      'assets/images/correct logo.png',
      'assets/images/Game Over Menu.png',
      'assets/images/levels.png',
      'assets/images/lock.png',
      'assets/images/locked.png',
      'assets/images/logo.png',
      'assets/images/Paused Menu.png',
      'assets/images/plank wood.png',
      'assets/images/player profile.png',
      'assets/images/Purchase.png',
      'assets/images/question background.png',
      'assets/images/settings.png',
    ];

    for (var image in images) {
      await precacheImage(AssetImage(image), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Jasmieture',
      theme: ThemeData(
        fontFamily: 'LuckiestGuy',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Settings up some default theme for elevated buttons.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            fixedSize: const Size(200, 60),
          ),
        ),
      ),
      routerConfig: routes,
      // home: GameScreen(),
    );
  }
}
