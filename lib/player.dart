import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/collidable_object.dart';
import 'package:flutter_application_1/flame_game.dart';
import 'package:flutter_application_1/states/normal_state.dart';
import 'package:flutter_application_1/states/player_state_manager.dart';
import 'package:flutter_application_1/states/propellor_state.dart';

class Player extends SpriteComponent
    with
        KeyboardHandler,
        CollisionCallbacks,
        HasGameReference<MyFirstFlameGame> {
  late double playerSpeed = 550;
  late double horzLerpAcc = 15;
  late double normalJumpV = -1000;
  late double springJumpV = -2000;

  late bool gameOver = false;
  late bool lookingLeft = false;
  double playerJumpDelta = 0;
  Vector2 velocity = Vector2.zero();
  late ShapeHitbox playerHitbox;
  late PlayerStateManager stateManager = PlayerStateManager(game, this);
  late Set<LogicalKeyboardKey> keysDown = {};
  final Vector2 screenSize;
  final String playerPNG = 'jumper_sprite.png';

  Player({super.position, required this.screenSize})
    : super(size: Vector2.all(70), anchor: Anchor.bottomCenter);

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
    if (keysDown.contains(LogicalKeyboardKey.keyR)) {
      game.onRestart();
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
    if (other is! CollidableObject) return;
    void handlePlatformCollision(PositionComponent other) {
      double tolerance = other.size.y / 3;
      if (velocity.y > 0 && position.y < other.position.y + tolerance) {
        if (stateManager.activeState is NormalState) {
          (stateManager.activeState as NormalState).jump(normalJumpV);
        }
      }
    }

    void handleSpringCollision(PositionComponent other) {
      double tolerance = other.size.y / 2;
      if (velocity.y > 0 && position.y < other.position.y + tolerance) {
        (stateManager.activeState as NormalState).jump(springJumpV);
      }
    }

    void handlePropellorCollision(PositionComponent other) {
      stateManager.switchState('propellor');
      other.removeFromParent();
    }

    void handleJetPackCollision(PositionComponent other) {
      stateManager.switchState('jetpack');
      other.removeFromParent();
    }

    switch (other.collisionType) {
      case 'jetpack':
        handleJetPackCollision(other);
        break;
      case 'platform':
        handlePlatformCollision(other);
        break;
      case 'spring':
        handleSpringCollision(other);
        break;
      case 'propellor':
        if (stateManager.activeState is PropellorState) break;
        handlePropellorCollision(other);
        break;
      default:
        break;
    }
  }
}
