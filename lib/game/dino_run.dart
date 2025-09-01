import 'package:dino_run/game/rive_character.dart';
import 'package:dino_run/view_models.dart/quiz_data.dart';
import 'package:dino_run/widgets/question_panel.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '/game/dino.dart';
import '/widgets/hud.dart';
import '/models/settings.dart';
import '/game/audio_manager.dart';
import '/game/enemy_manager.dart';
import '/models/player_data.dart';
import '/widgets/pause_menu.dart';
import '/widgets/game_over_menu.dart';

import 'package:flame_rive/flame_rive.dart';

// This is the main flame game class.
class DinoRun extends FlameGame with TapDetector, HasCollisionDetection, KeyboardEvents {
  final Settings settings;
  final PlayerData playerData;
  final QuizData quizData;

  DinoRun({super.camera, required this.playerData, required this.settings, required this.quizData});

  // List of all the image assets.
  static const _imageAssets = [
    'DinoSprites - tard.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
    'Rino/Run (52x34).png',
    'parallax/plx-1.png',
    'parallax/plx-2.png',
    'parallax/plx-3.png',
    'parallax/plx-4.png',
    'parallax/plx-5.png',
    'parallax/plx-6.png',
    // 'parallax/1.png',
    // 'parallax/2.png',
    // 'parallax/3.png',
    // 'parallax/4.png',
  ];

  // List of all the audio assets.
  static const _audioAssets = [
    '8BitPlatformerLoop.wav',
    'hurt7.wav',
    'jump14.wav',
  ];

  // late Dino _dino;
  // late Settings settings;
  // late PlayerData playerData;
  late EnemyManager _enemyManager;

  late SkillsAnimationComponent _runningCharacter;
  late Artboard characterArtboard;

  Vector2 get virtualSize => camera.viewport.virtualSize;

  // TODO - TESTING on passing buildContext inside game component
  @override
  // late BuildContext buildContext;
  // ------------------------------------------------------------

  // This method get called while flame is preparing this game.
  @override
  Future<void> onLoad() async {
    await quizData.initialize(quizData.level, quizData.chapter);

    //
    // TODO - TESTING on passing buildContext inside game component
    //
    //
    // Access PlayerData from Provider
    // testProvider = Provider.of<TestProvider>(
    //   buildContext, // You get buildContext from GameWidget
    //   listen: false,
    // );

    print('${playerData.character} -===');

    characterArtboard = await loadArtboard(RiveFile.asset('assets/rive/running_and_jumping (9).riv'),
        artboardName: playerData.character);

    // Makes the game full screen and landscape only.
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    /// Read [PlayerData] and [Settings] from hive.
    // playerData = await _readPlayerData();
    // settings = await _readSettings();

    print('bgm --------- ${settings.bgm}');

    /// Initilize [AudioManager].
    await AudioManager.instance.init(_audioAssets, settings);

    // Start playing background music. Internally takes care
    // of checking user settings.
    AudioManager.instance.startBgm('8BitPlatformerLoop.wav');

    // Cache all the images.
    await images.loadAll(_imageAssets);

    // This makes the camera look at the center of the viewport.
    camera.viewfinder.position = camera.viewport.virtualSize * 0.5;

    /// Create a [ParallaxComponent] and add it to game.
    final parallaxBackground = await loadParallaxComponent(
      [
        ParallaxImageData('parallax/plx-1.png'),
        ParallaxImageData('parallax/plx-2.png'),
        ParallaxImageData('parallax/plx-3.png'),
        ParallaxImageData('parallax/plx-4.png'),
        // ParallaxImageData('parallax/plx-5.png'),
        ParallaxImageData('parallax/001.png'),
        // ParallaxImageData('parallax/plx-custom.png'),
        ParallaxImageData('parallax/plx-6.png'),

        // ParallaxImageData('parallax/1.png'),
        // ParallaxImageData('parallax/2.png'),
        // ParallaxImageData('parallax/3.png'),
        // ParallaxImageData('parallax/4.png'),
        // ParallaxImageData('parallax/plx-6.png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );

    // Add the parallax as the backdrop.
    camera.backdrop.add(parallaxBackground);

    // _dino = Dino(images.fromCache('DinoSprites - tard.png'), playerData);
    _runningCharacter = SkillsAnimationComponent(
      characterArtboard,
      playerData: playerData,
    ); // TO-DO - Add playerData Here, to access the selected items settings - DONE

    startGamePlay();
    overlays.add(Hud.id);
  }

  /// This method add the already created [Dino]
  /// and [EnemyManager] to this game.
  ///
  /// Params => level,
  ///
  void startGamePlay() async {
    _enemyManager = EnemyManager();

    // world.add(_dino);

    world.add(_runningCharacter);

    world.add(_enemyManager);

    // playerData.level = 2;
  }

  // This method remove all the actors from the game.
  void _disconnectActors() {
    // _dino.removeFromParent();
    _runningCharacter.removeFromParent();

    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
  }

  // This method reset the whole game world to initial state.
  void reset() {
    // First disconnect all actions from game world.
    _disconnectActors();

    // Reset player data to inital values.
    playerData.currentScore = 0;
    playerData.lives = 5;
  }

  // This method gets called for each tick/frame of the game.
  @override
  void update(double dt) {
    // If number of lives is 0 or less, game is over.
    if (quizData.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(Hud.id);
      pauseEngine();
      AudioManager.instance.pauseBgm();
    }

    // Show Question when the character hits enemy
    if (_runningCharacter.isHit) {
      // _dino.isHit = false;
      _runningCharacter.isHit = false;
    }

    super.update(dt);
  }

  // This will get called for each tap on the screen.
  @override
  void onTapDown(TapDownInfo info) {
    // Make dino jump only when game is playing.
    // When game is in playing state, only Hud will be the active overlay.
    if (overlays.isActive(Hud.id)) {
      // _dino.jump();
      _runningCharacter.jump();
    }
    super.onTapDown(info);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    print(event);
    final isKeyDown = event is KeyDownEvent;

    if (isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.space) || keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        // _dino.jump();
        _runningCharacter.jump();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        // _dino.down();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // On resume, if active overlay is not PauseMenu,
        // resume the engine (lets the parallax effect play).
        if (!(overlays.isActive(PauseMenu.id)) &&
            !(overlays.isActive(GameOverMenu.id)) &&
            !(overlays.isActive(QuestionOverlay.id))) {
          resumeEngine();
        }
        // quizData.startTimer();

        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // If game is active, then remove Hud and add PauseMenu
        // before pausing the game.
        if (overlays.isActive(Hud.id)) {
          overlays.remove(Hud.id);

          if (!overlays.isActive(GameOverMenu.id)) {
            overlays.add(PauseMenu.id);
          }
        }
        AudioManager.instance.pauseBgm();
        pauseEngine();
        // quizData.pauseTimer();

        break;
    }
    super.lifecycleStateChange(state);
  }
}
