import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_application_1/collidable_object.dart';

class Spring extends SpriteComponent implements CollidableObject {
  @override
  late String collisionType = 'spring';
  late ShapeHitbox springHitbox;
  Spring({super.position})
    : super(size: Vector2(15, 15), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Images().load('tiles_spritesheet.png');
    final tileFrame = Sprite(
      spriteSheet,
      srcPosition: Vector2(404, 99),
      srcSize: Vector2(17, 12),
    );
    sprite = tileFrame;

    springHitbox = RectangleHitbox(size: size)
      ..collisionType = CollisionType.passive;

    add(springHitbox);
  }
}
