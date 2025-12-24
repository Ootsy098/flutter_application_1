import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flutter_application_1/platforms/platform.dart';
import 'package:flutter_application_1/player.dart';

class BreakablePlatform extends RegularPlatform {
  final List<Vector2> framesPositions = [
    Vector2(1, 73),
    Vector2(0, 90),
    Vector2(0, 116),
    Vector2(0, 148),
  ];
  final List<Vector2> framesSizes = [
    Vector2(60, 15),
    Vector2(60, 20),
    Vector2(60, 27),
    Vector2(60, 32),
  ];

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Images().load('tiles_spritesheet.png');
    final tileFrame = Sprite(
      spriteSheet,
      srcPosition: Vector2(1, 73),
      srcSize: Vector2(60, 15),
    );
    sprite = tileFrame;
    platformHitbox = RectangleHitbox(size: size)
      ..collisionType = CollisionType.passive;

    add(platformHitbox);
    game.highestPlatformY = position.y;
    position.x = position.x.clamp(0 + size.x / 2, game.size.x - size.x / 2);

    checkIsBelowCam(0, 0);
  }

  void breakPlatform() {
    removeFromParent();
  }

  @override
  void executeStrategy(Player player) {
    breakPlatform();
    return;
  }
}
