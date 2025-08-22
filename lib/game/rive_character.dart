import 'dart:async';

import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/game/dino_run.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/widgets/question_panel.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flame/collisions.dart';

enum CharacterAnimationStates { idle, run, kick, hit, sprint }

class SkillsAnimationComponent extends RiveComponent with CollisionCallbacks, HasGameReference<DinoRun> {
  SkillsAnimationComponent(Artboard artboard, {required this.playerData})
      : super(artboard: artboard, size: Vector2.all(50));

  final PlayerData playerData;

  // The max distance from top of the screen beyond which
  // dino should never go. Basically the screen height - ground height
  double yMax = 0.0;

  // Dino's current speed along y-axis.
  double speedY = 0.0;

  // Controlls how long the hit animations will be played.
  final Timer _hitTimer = Timer(1);

  static const double gravity = 800;

  SMIInput<bool>? _jump;
  SMIInput<double>? _character;
  SMIInput<double>? _hair_item;
  SMIInput<double>? _glasses_item;
  SMIInput<double>? _shirt_item;

  bool isHit = false;

  @override
  void onMount() {
    _reset();
    yMax = y;

    /// Set the callback for [_hitTimer].
    _hitTimer.onTick = () {
      isHit = false;
    };

    super.onMount();
  }

  @override
  FutureOr<void> onLoad() {
    debugMode = false;

    final controller = StateMachineController.fromArtboard(
      artboard,
      "State Machine",
      onStateChange: (stateMachineName, stateName) {
        print(stateName);
      },
    );

    if (controller != null) {
      artboard.addController(controller);
      _jump = controller.findInput<bool>('Jump');
      _hair_item = controller.findInput<double>('head_choices');
      _glasses_item = controller.findInput<double>('eye_choices');
      _shirt_item = controller.findInput<double>('shirt_print_choices');
      _jump?.value = false;

      _hair_item?.value = playerData.headItem;
      _glasses_item?.value = playerData.eyeItem;
      _shirt_item?.value = playerData.shirtItem;
    }

    // Add a hitbox for character.
    add(
      RectangleHitbox.relative(
        Vector2(0.5, 0.7),
        parentSize: size,
        position: Vector2(size.x * 0.5, size.y * 0.3) / 2,
      ),
    );

    super.onLoad();
  }

  @override
  void update(double dt) {
    // v = u + at
    speedY += gravity * dt;

    // d = s0 + s * t
    y += speedY * dt;

    /// This code makes sure that character never goes beyond [yMax].
    if (isOnGround) {
      y = yMax;
      speedY = 0.0;
    }

    _hitTimer.update(dt);
    super.update(dt);
  }

  // Returns true if dino is on ground.
  bool get isOnGround => (y >= yMax);

  // This method reset some of the important properties
  // of this component back to normal.
  void _reset() {
    if (isMounted) {
      removeFromParent();
    }
    anchor = Anchor.bottomLeft;
    position = Vector2(20, game.virtualSize.y - 18);
    speedY = 0.0;
  }

  // Makes the dino jump.
  void jump() {
    // Jump only if dino is on ground.
    // _jump?.value = true;
    if (isOnGround) {
      speedY = -300;

      // Jump animation of rive character
      _jump?.value = true;
      // current = DinoAnimationStates.idle;
      // AudioManager.instance.playSfx('jump14.wav');
    }
  }

  // Gets called when dino collides with other Collidables.
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (intersectionPoints.isEmpty || other is! Enemy || isHit) return;

    // Get center of your current component
    final myCenter = absoluteCenter;
    // Get average of intersection points
    final collisionPoint = intersectionPoints.reduce((a, b) => a + b) / intersectionPoints.length.toDouble();

    // Get the difference vector
    final diff = collisionPoint - myCenter;

    final dx = diff.x.abs();
    final dy = diff.y.abs();

    if (dx > dy) {
      if (diff.x > 0) {
        print("Hit on RIGHT");
      } else {
        print("Hit on LEFT");
      }
    } else {
      if (diff.y > 0) {
        print("Hit on BOTTOM");
      } else {
        print("Hit on TOP");
      }
    }

    other.removeFromParent();
    hit();
  }

  void hit() {
    isHit = true;
    AudioManager.instance.playSfx('hurt7.wav');
    _hitTimer.start();
    // playerData.lives -= 1;
    game.pauseEngine();

    game.overlays.add(QuestionOverlay.id);
  }
}
