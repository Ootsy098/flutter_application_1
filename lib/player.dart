import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/flame_game.dart';

class Player extends SpriteComponent
    with
        KeyboardHandler,
        CollisionCallbacks,
        HasGameReference<MyFirstFlameGame> {
  late double playerSpeed = 550;
  late double horzLerpAcc = 15;
  late double normalJumpV = -1000;
  late double gravityC = 1600;
  late bool firstJumpIsDone = false;
  double playerJumpDelta = 0;
  Vector2 velocity = Vector2.zero();
  late ShapeHitbox playerHitbox;

  late Set<LogicalKeyboardKey> keysDown = {};
  final Vector2 screenSize;
  final String playerPNG = 'jumper_sprite.png';

  Player({super.position, required this.screenSize})
    : super(size: Vector2.all(100), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(playerPNG);
    playerHitbox = RectangleHitbox(
      size: Vector2(size.x - 40, size.y),
      position: Vector2(10, 0),
    )..collisionType = CollisionType.active;
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
    if (keysDown.contains(LogicalKeyboardKey.arrowLeft) &&
        !keysDown.contains(LogicalKeyboardKey.arrowRight)) {
      inputMove(-1, dt);
    } else if (keysDown.contains(LogicalKeyboardKey.arrowRight) &&
        !keysDown.contains(LogicalKeyboardKey.arrowLeft)) {
      inputMove(1, dt);
    } else {
      velocity.x = lerpDouble(velocity.x, 0, horzLerpAcc * dt)!;
    }
    applyGravity(dt);
    position += velocity * dt;
    if (!firstJumpIsDone && velocity.y <= 0) {
      firstJumpIsDone = true;
      playerJumpDelta += position.y;
      game.maxPlatformGap = playerJumpDelta * 0.8;
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
    if (position.x < -size.x / 2) {
      position.x = screenSize.x + size.x / 2;
    } else if (position.x > screenSize.x + size.x / 2) {
      position.x = -size.x / 2;
    }
  }

  void applyGravity(double dt) {
    if (position.y < screenSize.y) {
      velocity.y += gravityC * dt;
    } else {
      jump(normalJumpV);
      position.y = screenSize.y;
    }
  }

  void jump(double upwardsVelocity) {
    if (!firstJumpIsDone) {
      playerJumpDelta = position.y;
    }
    velocity.y = upwardsVelocity;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (velocity.y > 0 && position.y < other.position.y) {
      jump(normalJumpV);
    }
  }
}
