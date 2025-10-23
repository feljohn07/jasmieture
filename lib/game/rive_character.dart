import 'dart:async';
import 'dart:ui';

import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/game/dino_run.dart';
import 'package:dino_run/game/enemy.dart';
import 'package:dino_run/models/player_data.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/view_models.dart/shop_data.dart';
import 'package:dino_run/widgets/question_panel.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flame/collisions.dart';

enum CharacterAnimationStates { idle, run, kick, hit, sprint }

class SkillsAnimationComponent extends RiveComponent with CollisionCallbacks, HasGameReference<DinoRun> {
  final PlayerData playerData;
  final ShopData shopData;

  SkillsAnimationComponent(Artboard artboard, {required this.shopData, required this.playerData})
      : super(artboard: artboard, size: Vector2.all(60));

  late final CircleComponent _shadow;

  // The max distance from top of the screen beyond which
  // dino should never go. Basically the screen height - ground height
  double yMax = 0.0;

  // Dino's current speed along y-axis.
  double speedY = 0.0;

  // Controlls how long the hit animations will be played.
  final Timer _hitTimer = Timer(1);

  static const double gravity = 800;

  SMIInput<bool>? _jump;
  SMIInput<double>? _hairItem;
  SMIInput<double>? _glassesItem;
  SMIInput<double>? _shirtItem;

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
  FutureOr<void> onLoad() async {
    // debugMode = true;

    _shadow = CircleComponent(
      radius: size.x / 4, // Base the shadow size on the player's size
      anchor: Anchor.center,
      paint: Paint()..color = const Color.fromARGB(104, 0, 0, 0),
    );

    _shadow.scale = Vector2(1.0, 0.4);

    _shadow.position = Vector2(
      x + width - 15,
      game.virtualSize.y - 20,
    );

    _shadow.priority = -1;

    await parent?.add(_shadow);

    final controller = StateMachineController.fromArtboard(
      artboard,
      "State Machine",
      // onStateChange: (stateMachineName, stateName) {
      //   print(stateName);
      // },
    );

    if (controller != null) {
      artboard.addController(controller);
      _jump = controller.findInput<bool>('Jump');
      _hairItem = controller.findInput<double>('head_choices');
      _glassesItem = controller.findInput<double>('eye_choices');
      _shirtItem = controller.findInput<double>('shirt_print_choices');
      _jump?.value = false;

      _hairItem?.value = shopData.shop.headItemSelected.riveId;
      _glassesItem?.value = shopData.shop.eyeItemSelected.riveId;
      _shirtItem?.value = shopData.shop.shirtItemSelected.riveId;
    }

    // Add a hitbox for character.
    add(
      RectangleHitbox.relative(
        Vector2(0.40, 0.5), // TODO adjust hitbox
        parentSize: size,
        position: Vector2(size.x * 0.6, size.y * 0.6) / 2,
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

      _shadow.paint.color = const Color(0xFF000000).withOpacity(0.3);
      _shadow.scale = Vector2(1.0, 0.4);
    } else {
      // _jump?.value = false;

      const maxJumpHeight = 60.0; // Estimated max jump height in pixels.
      final jumpHeight = (yMax - y).abs();
      final percentage = (jumpHeight / maxJumpHeight).clamp(0.0, 1.0);

      // Interpolate opacity and scale based on height.
      final newOpacity = 0.3 - (percentage * 0.25);
      final newScale = 1.0 - (percentage * 0.4);

      _shadow.paint.color = const Color(0xFF000000).withOpacity(newOpacity.clamp(0.0, 0.3));
      // This maintains the oval shape while scaling.
      _shadow.scale = Vector2(newScale.clamp(0.0, 1.0), (newScale / 2.5).clamp(0.0, 0.4));
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
    if (isOnGround) {
      speedY = -300;
      // Jump animation of rive character
      _jump?.value = true;
      AudioManager.instance.playSfx(AudioSfx.jump);
    }
  }

  // Gets called when dino collides with other Collidables.
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
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
    AudioManager.instance.playSfx(AudioSfx.hurt);
    _hitTimer.start();
    game.pauseEngine();
    game.overlays.add(QuestionOverlay.id);
  }
}
