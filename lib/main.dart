import 'dart:convert';

import 'package:dino_run/repositories/implementations/hive_lesson_repository.dart';
import 'package:dino_run/routes/routes.dart';
import 'package:dino_run/utils/level_parser.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:dino_run/widgets/question_panel.dart';
import 'package:flame/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'widgets/hud.dart';
import 'game/dino_run.dart';
import 'models/settings.dart';
import 'widgets/main_menu.dart';
import 'models/player_data.dart';
import 'widgets/pause_menu.dart';
import 'widgets/settings_menu.dart';
import 'widgets/game_over_menu.dart';

import 'package:easy_localization/easy_localization.dart';

final lessonRepository = HiveLessonRepository();

Future<void> main() async {
  // Ensures that all bindings are initialized
  // before was start calling hive and flame code
  // dealing with platform channels.
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  await EasyLocalization.ensureInitialized();

  await Hive.deleteFromDisk();
  await initHive();

  /// This method reads [PlayerData] from the hive box.
  Future<PlayerData> readPlayerData() async {
    // Hive.deleteBoxFromDisk('DinoRun.PlayerDataBox');
    final playerDataBox = await Hive.openBox<PlayerData>(
      'DinoRun.PlayerDataBox',
    );

    final playerData = playerDataBox.get('DinoRun.PlayerData');

    // If data is null, this is probably a fresh launch of the game.
    if (playerData == null) {
      // In such cases store default values in hive.
      await playerDataBox.put('DinoRun.PlayerData', PlayerData());
    }

    // Now it is safe to return the stored value.
    return playerDataBox.get('DinoRun.PlayerData')!;
  }

  /// This method reads [Settings] from the hive box.
  Future<Settings> readSettings() async {
    final settingsBox = await Hive.openBox<Settings>('DinoRun.SettingsBox');
    final settings = settingsBox.get('DinoRun.Settings');

    // If data is null, this is probably a fresh launch of the game.
    if (settings == null) {
      // In such cases store default values in hive.
      await settingsBox.put('DinoRun.Settings', Settings(bgm: true, sfx: true));
    }

    // Now it is safe to return the stored value.
    return settingsBox.get('DinoRun.Settings')!;
  }

  // Initializes hive and register the adapters.
  final playerData = await readPlayerData();
  final settings = await readSettings();
  final quizData = QuizData(lessonRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => playerData),
        ChangeNotifierProvider(create: (_) => quizData),
        ChangeNotifierProvider(create: (_) => settings),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('fil')],
        path: 'assets/translations', // <-- JSON files
        fallbackLocale: const Locale('en'),
        child: DinoRunApp(),
      ),
    ),
  );
  // runApp(const LevelScreen());
  // runApp(const ShopScreen());
}

// This function will initilize hive with apps documents directory.
// Additionally it will also register all the hive adapters.
Future<void> initHive() async {
  // For web hive does not need to be initialized.
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  Hive.registerAdapter<PlayerData>(PlayerDataAdapter());
  Hive.registerAdapter<Settings>(SettingsAdapter());
  
  await lessonRepository.init();
  await initializeQuestions();
}

Future<void> initializeQuestions() async {
  String jsonString = await rootBundle.loadString('assets/json/questions.json');
  await lessonRepository.saveLevels(
    LevelParser.fromJson(jsonDecode(jsonString)),
  );

  print((await lessonRepository.getAllLevels()).length);
}

// The main widget for this game.
class DinoRunApp extends StatelessWidget {
  const DinoRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// TODO -> move the changenotifier provider up to a new mainApp widget so we can open the game only after everything is set.
    ///
    /// 1. Create MainApp widget for ui like, settings, shop, profile and levels etc.
    /// 2. pass the BuildContext to the Game Component so we can easily access the context for listening to changes
    ///

    return MaterialApp.router(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      title: 'Dino Run',
      theme: ThemeData(
        fontFamily: 'Audiowide',
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

class GameScreen extends StatelessWidget {
  const GameScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<DinoRun>.controlled(
        // This will dislpay a loading bar until [DinoRun] completes
        // its onLoad method.
        loadingBuilder: (conetxt) => const Center(
          child: SizedBox(width: 200, child: LinearProgressIndicator()),
        ),
        // Register all the overlays that will be used by this game.
        overlayBuilderMap: {
          MainMenu.id: (_, game) => MainMenu(game),
          PauseMenu.id: (_, game) => PauseMenu(game),
          Hud.id: (_, game) => Hud(game),
          GameOverMenu.id: (_, game) => GameOverMenu(game),
          // SettingsMenu.id: (_, game) => SettingsMenu(game),
          SettingsMenu.id: (_, game) => SettingsMenu(),
          QuestionOverlay.id: (_, game) => QuestionOverlay(game),
          // ShopScreen.id: (_, game) => ShopScreen(game),
        },
        // By default MainMenu overlay will be active.
        // initialActiveOverlays: const [MainMenu.id],
        gameFactory: () => DinoRun(
          playerData: Provider.of<PlayerData>(context, listen: false),
          settings: Provider.of<Settings>(context, listen: false),
          quizData: Provider.of<QuizData>(context, listen: false),
          // Use a fixed resolution camera to avoid manually
          // scaling and handling different screen sizes.
          camera: CameraComponent.withFixedResolution(
            width: 360,
            height: 180,
          ),
        ),
        // ..buildContext = context,
      ),
    );
  }
}

// class TestProvider extends ChangeNotifier {
//   int testValue = 0;

//   increment() {
//     testValue++;
//     notifyListeners();
//   }
// }
