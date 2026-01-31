import 'dart:convert';
// Add this import for Completer
import 'dart:async';

import 'package:dino_run/repositories/implementations/game_history_repository_impl.dart';
import 'package:dino_run/screens/game_intro_screen.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'package:dino_run/repositories/data/datasource.dart';
import 'package:dino_run/repositories/implementations/player_repository_impl.dart';
import 'package:dino_run/repositories/implementations/settings_repository_impl.dart';
import 'package:dino_run/view_models.dart/language_provider.dart';

import 'app.dart';
import 'core/utils/level_parser.dart';
import 'game/audio_manager.dart';
import 'models/player_data.dart';
import 'models/settings.dart';
import 'repositories/implementations/lesson_repository_impl.dart';
import 'repositories/implementations/shop_repository_impl.dart';
import 'repositories/implementations/soloud_audio_repository_imp.dart';
import 'view_models.dart/quiz_data.dart';
import 'view_models.dart/rive_provider.dart';
import 'view_models.dart/shop_data.dart';

final datasource = Datasource();

final lessonRepository = LessonRepositoryImpl(datasource: datasource);
final shopRepository = ShopRepositoryImpl(datasource: datasource);
final playerRepository = PlayerRepositoryImp(datasource: datasource);
final settingsRepository = SettingsRepositoryImp(datasource: datasource);
final historyRepository = GameHistoryRepositoryImpl(datasource: datasource);
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // 1. Preserve splash (standard setup)
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  // --- START INTRO SEQUENCE ---

  // A Completer allows us to wait for the UI widget to finish its animation
  final introCompleter = Completer<void>();

  // Run the Intro Widget immediately
  runApp(GameIntroScreen(
    onIntroCompleted: () {
      if (!introCompleter.isCompleted) {
        introCompleter.complete();
      }
    },
  ));

  // 3. Immediately remove the Native Splash so we can see the White Screen
  FlutterNativeSplash.remove();

  await initHive();
  await RiveFile.initialize();

  final playerData = PlayerData(playerRepository);
  final settingsData = SettingsData(settingsRepository);
  final languageProvider = LanguageProvider(settingsRepository);
  final quizData = QuizData(lessonRepository, settingsRepository, historyRepository);
  final shopData = ShopData(shopRepository: shopRepository);
  final riveProvider = RiveProvider();

  await riveProvider.initRive(shopData.shop);
  await AudioManager.instance.init(settingsData, SoloudAudioRepositoryImp());

  // --- SYNCHRONIZATION ---

  // Critical: Wait here until the Intro Animation is actually finished.
  // This prevents the game from cutting off the School Logo early.
  await introCompleter.future;

  // 5. Run the actual App (Replaces the White Screen)
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => languageProvider),
        ChangeNotifierProvider(create: (_) => playerData),
        ChangeNotifierProvider(create: (_) => quizData),
        ChangeNotifierProvider(create: (_) => settingsData),
        ChangeNotifierProvider(create: (_) => shopData),
        ChangeNotifierProvider(create: (_) => riveProvider),
      ],
      child: DinoRunApp(),
    ),
  );
}

Future<void> initHive() async {
  await datasource.initialize();
  await initializeQuestions();
}

Future<void> initializeQuestions() async {
  String englishLesson = await rootBundle.loadString('assets/questions/questions_eng.json'); // english lesson
  await lessonRepository.saveLevels('english', LevelParser.fromJson(jsonDecode(englishLesson)));

  String cebuanoLesson = await rootBundle.loadString('assets/questions/questions_ceb.json'); // cebuano lesson
  await lessonRepository.saveLevels('cebuano', LevelParser.fromJson(jsonDecode(cebuanoLesson)));
}
