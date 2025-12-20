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

    double distance =
        rng.nextDouble() * (game.maxPlatformGap - game.minPlatformGap) +
        game.minPlatformGap;
    position.y = game.highestPlatformY - distance;
    game.highestPlatformY = position.y;
  }
}
