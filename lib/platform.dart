import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class RegularPlatform extends SpriteComponent {
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
  }

  void descendPlatform(double v, double dt, double screenHeight) {
    position.y += v.abs() * dt;

    if (position.y > screenHeight + size.y) removeFromParent();
  }
}
