import 'package:dino_run/game/dino_run.dart';
import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/models/settings.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:dino_run/view_models.dart/rive_provider.dart';
import 'package:dino_run/view_models.dart/shop_data.dart';
import 'package:dino_run/widgets/game_completed_menu.dart';
import 'package:dino_run/widgets/game_over_menu.dart';
import 'package:dino_run/widgets/hud.dart';
import 'package:dino_run/widgets/main_menu.dart';
import 'package:dino_run/widgets/pause_menu.dart';
import 'package:dino_run/widgets/question_panel.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          GameCompletedMenu.id: (_, game) => GameCompletedMenu(game),
          // SettingsMenu.id: (_, game) => SettingsMenu(game),
          // SettingsMenu.id: (_, game) => SettingsMenu(),
          QuestionOverlay.id: (_, game) => QuestionOverlay(game),
          // ShopScreen.id: (_, game) => ShopScreen(game),
        },
        // By default MainMenu overlay will be active.
        // initialActiveOverlays: const [MainMenu.id],
        gameFactory: () => DinoRun(
          playerData: Provider.of<PlayerData>(context, listen: false),
          settings: Provider.of<SettingsData>(context, listen: false),
          quizData: Provider.of<QuizData>(context, listen: false),
          shopData: Provider.of<ShopData>(context, listen: false),
          riveProvider: Provider.of<RiveProvider>(context, listen: false),
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
