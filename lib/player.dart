import 'dart:ui';
import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/collidable_object.dart';
import 'package:flutter_application_1/flame_game.dart';
import 'package:flutter_application_1/states/normal_state.dart';
import 'package:flutter_application_1/states/player_state_manager.dart';

class Player extends SpriteComponent
    with
        KeyboardHandler,
        CollisionCallbacks,
        HasGameReference<MyFirstFlameGame> {
  late double playerSpeed = 350;
  late double horzLerpAcc = 15;
  late double normalJumpV = -800;
  late double springJumpV = -1300;

  late bool gameOver = false;
  late bool lookingLeft = false;
  double playerJumpDelta = 0;
  Vector2 velocity = Vector2.zero();
  late ShapeHitbox playerHitbox;
  late PlayerStateManager stateManager = PlayerStateManager(game, this);
  late Set<LogicalKeyboardKey> keysDown = {};
  final Vector2 screenSize;
  final String playerPNG = 'jumper_sprites.png';
  final double jumpAnimationDurationReset = 0.25;
  late double jumpAnimationDuration;
  bool animatingJump = false;

  Player({super.position, required this.screenSize})
    : super(size: Vector2.all(62), anchor: Anchor.bottomCenter) {
    priority = 10;
  }

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Images().load(playerPNG);
    final tileFrame = Sprite(
      spriteSheet,
      srcPosition: Vector2(0, 0),
      srcSize: size,
    );
    sprite = tileFrame;
    jumpAnimationDuration = jumpAnimationDurationReset;
    velocity.y = normalJumpV * 0.6;

    playerHitbox = RectangleHitbox(
      size: Vector2(size.x - 10, size.y),
      position: Vector2(10, 0),
    )..collisionType = CollisionType.active;
    debugMode = true;
    add(playerHitbox);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      keysDown.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      keysDown.remove(event.logicalKey);
    }
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (keysDown.contains(LogicalKeyboardKey.keyR)) {
      game.onRestart();
    }
    if (gameOver) {
      return;
    }
    if (keysDown.contains(LogicalKeyboardKey.arrowLeft) &&
        !keysDown.contains(LogicalKeyboardKey.arrowRight)) {
      lookingLeft = true;
      inputMove(-1, dt);
    } else if (keysDown.contains(LogicalKeyboardKey.arrowRight) &&
        !keysDown.contains(LogicalKeyboardKey.arrowLeft)) {
      lookingLeft = false;
      inputMove(1, dt);
    } else {
      velocity.x = lerpDouble(velocity.x, 0, horzLerpAcc * dt)!;
    }
    position += velocity * dt;

    stateManager.activeState.stateUpdate(dt);

    jumpAnimationDuration -= dt;
    if (animatingJump && jumpAnimationDuration <= 0) {
      animatingJump = false;
      sprite!.srcPosition = Vector2.zero();
    }
  }

  void inputMove(int dir, double dt) {
    velocity.x = lerpDouble(velocity.x, playerSpeed * dir, horzLerpAcc * dt)!;
    if (dir == 1 && isFlippedHorizontally) {
      flipHorizontallyAroundCenter();
    } else if (dir == -1 && !isFlippedHorizontally) {
      flipHorizontallyAroundCenter();
    }
    teleport();
  }

  void teleport() {
    if (position.x < 0) {
      position.x = screenSize.x;
    } else if (position.x > screenSize.x) {
      position.x = 0;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (stateManager.activeState is! NormalState) {
      return;
    }
    if (other is CollidableObject) {
      other.executeStrategy(this);
    }
  }

  void enableJumpAnimation() {
    jumpAnimationDuration = jumpAnimationDurationReset;
    animatingJump = true;
    sprite!.srcPosition = Vector2(size.x, 4);
  }
}
