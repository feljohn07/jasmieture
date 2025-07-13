import 'dart:async';

import 'package:dino_run/game/dino_run.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flame/collisions.dart';

enum CharacterAnimationStates { idle, run, kick, hit, sprint }

class SkillsAnimationComponent extends RiveComponent with CollisionCallbacks, HasGameReference<DinoRun> {
  SkillsAnimationComponent(Artboard artboard) : super(artboard: artboard, size: Vector2.all(50));

  // The max distance from top of the screen beyond which
  // dino should never go. Basically the screen height - ground height
  double yMax = 0.0;

  // Dino's current speed along y-axis.
  double speedY = 0.0;

  // Controlls how long the hit animations will be played.
  final Timer _hitTimer = Timer(1);

  static const double gravity = 800;

  SMIInput<bool>? _jump;
  SMIInput<int>? _character;
  SMIInput<int>? _hair_item;
  SMIInput<int>? _glasses_item;
  SMIInput<int>? _shirt_item;

  @override
  void onMount() {
    _reset();
    yMax = y;
    super.onMount();
  }

  @override
  FutureOr<void> onLoad() {
    debugMode = true;

    final controller = StateMachineController.fromArtboard(
      artboard,
      "State Machine 1",
      onStateChange: (stateMachineName, stateName) {
        print(stateName);
      },
    );
    
    if (controller != null) {
      artboard.addController(controller);
      _jump = controller.findInput<bool>('Jump');
      _hair_item = controller.findInput<int>('Jump');
      _glasses_item = controller.findInput<int>('Jump');
      _shirt_item = controller.findInput<int>('Jump');
      _jump?.value = false;
      
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
    position = Vector2(32, game.virtualSize.y - 22);
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

  void switchHairItem({int item = 0}) {

  }
}
