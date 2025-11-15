import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Player extends SpriteComponent with KeyboardHandler {
  late double playerSpeed = 600;
  late double horzLerpAcc = 15;
  late double normalJumpV = -1000;
  late double gravityC = 20;
  Vector2 velocity = Vector2.zero();
  late Set<LogicalKeyboardKey> keysDown = {};
  final Vector2 screenSize;
  final String playerPNG = 'jumper_sprite.png';

  Player({super.position, required this.screenSize})
    : super(size: Vector2.all(100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(playerPNG);
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
      velocity.x = 0;
    }
    position += velocity * dt;
    applyGravity();
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

  void applyGravity() {
    if (position.y < screenSize.y - size.y / 2) {
      velocity.y += gravityC;
    } else {
      jump(normalJumpV);
      position.y = screenSize.y - size.y / 2;
    }
  }

  void jump(double upwardsVelocity) {
    velocity.y = upwardsVelocity;
  }
}
