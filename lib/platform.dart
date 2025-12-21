import 'dart:math';
import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_application_1/collidable_object.dart';
import 'package:flutter_application_1/flame_game.dart';
import 'package:flutter_application_1/propellor.dart';
import 'package:flutter_application_1/spring.dart';

class RegularPlatform extends SpriteComponent
    with HasGameReference<MyFirstFlameGame>
    implements CollidableObject {
  @override
  late String collisionType = 'platform';

  late final ShapeHitbox platformHitbox;
  late final hasSpringChance = 0.05;
  late final hasPropellorChance = 1;
  late SpriteComponent objectOnPlatform;
  late bool hasObject = false;

  RegularPlatform({super.position})
    : super(size: Vector2(80, 20), anchor: Anchor.center);

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
    position.x = position.x.clamp(0 + size.x / 2, game.size.x - size.x / 2);

    checkIsBelowCam(0, 0);
    addObjectToPlatform();
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
    position.x = rng.nextDouble() * (game.size.x - size.x) + size.x / 2;

    double distance = calculatePlatformGap(
      game.playerScore.score,
      game.minPlatformGap,
      game.maxPlatformGap,
    );
    position.y = game.highestPlatformY - distance;
    game.highestPlatformY = position.y;
    if (hasObject) {
      game.camera.world?.remove(objectOnPlatform);
      hasObject = false;
    }

    addObjectToPlatform();
  }

  void addObjectToPlatform() {
    Random rng = Random();
    double randomNumber = rng.nextDouble();
    if (randomNumber > hasSpringChance) return;
    hasObject = true;
    double objectXOffset =
        (rng.nextDouble() * (size.x - 20)) - (size.x / 2 - 10);

    if (randomNumber <= hasPropellorChance) {
      objectOnPlatform = Propellor(
        position: Vector2(position.x + objectXOffset, position.y - size.y / 2),
      );
    } else if (randomNumber <= hasSpringChance) {
      objectOnPlatform = Spring(
        position: Vector2(position.x + objectXOffset, position.y - size.y / 2),
      );
    }

    game.camera.world?.add(objectOnPlatform);
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
      case >= 0 && < 2000:
        alteredMaxGap *= 0.2;
        break;
      case >= 2000 && < 6000:
        alteredMaxGap *= 0.3;
        break;
      case >= 6000 && < 10000:
        alteredMaxGap *= 0.4;
        break;
      case >= 10000 && < 14000:
        alteredMinGap *= 1.3;
        alteredMaxGap *= 0.7;
        break;
      case >= 14000:
        alteredMinGap *= 1.5;
        alteredMaxGap *= maxPossiblePlatformGap * 0.9;
        break;
      default:
        gap = 150;
    }
    gap = rng.nextDouble() * (alteredMaxGap - alteredMinGap) + alteredMinGap;
    return gap;
  }
}
