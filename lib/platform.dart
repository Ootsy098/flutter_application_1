import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_application_1/flame_game.dart';

class RegularPlatform extends SpriteComponent
    with HasGameReference<MyFirstFlameGame> {
  late final ShapeHitbox platformHitbox;

  RegularPlatform({super.position})
    : super(size: Vector2(100, 20), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Images().load('tiles_spritesheet.png');
    final tileFrame = Sprite(
      spriteSheet,
      srcPosition: Vector2(1, 1),
      srcSize: Vector2(57, 15),
    );
    sprite = tileFrame;
    platformHitbox = RectangleHitbox(size: size)
      ..collisionType = CollisionType.passive;

    add(platformHitbox);
    game.highestPlatformY = position.y;
  }

  void checkIsBelowCam(double v, double dt) {
    double cameraBottomY =
        game.camera.viewfinder.position.y + game.camera.viewport.size.y / 2;
    bool isBelowCamera = position.y > cameraBottomY;
    if (isBelowCamera) {
      resetPosition();
    }
  }

  void resetPosition() {
    final rng = Random();
    position.x = rng.nextDouble() * game.size.x;

    double distance = calculatePlatformGap(
      game.playerScore.score,
      game.minPlatformGap,
      game.maxPlatformGap,
    );
    position.y = game.highestPlatformY - distance;
    game.highestPlatformY = position.y;
  }

  static double calculatePlatformGap(
    int score,
    double minPlatformGap,
    double maxPossiblePlatformGap,
  ) {
    double gap = 0;
    double alteredMinGap = minPlatformGap;
    double alteredMaxGap = maxPossiblePlatformGap;
    Random rng = Random();

    switch (score) {
      case >= 0 && < 1000:
        alteredMaxGap *= 0.2;
        break;
      case >= 1000 && < 3000:
        alteredMaxGap *= 0.3;
        break;
      case >= 3000 && < 6000:
        alteredMaxGap *= 0.4;
        gap = 110;
        break;
      case >= 6000 && < 10000:
        alteredMinGap *= 1.3;
        alteredMaxGap *= 0.7;
        gap = 90;
        break;
      case >= 10000:
        alteredMinGap *= 1.5;
        alteredMaxGap *= maxPossiblePlatformGap * 0.9;
        gap = 70;
        break;
      default:
        gap = 150;
    }
    gap = rng.nextDouble() * (alteredMaxGap - alteredMinGap) + alteredMinGap;
    log(gap);
    return gap;
  }
}
