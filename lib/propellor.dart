import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_application_1/collidable_object.dart';

class Propellor extends SpriteComponent implements CollidableObject {
  @override
  late String collisionType = 'propellor';
  late ShapeHitbox propellorHitbox;
  Propellor({super.position})
    : super(size: Vector2(32, 32), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Images().load('propellor_animation.png');
    final tileFrame = Sprite(
      spriteSheet,
      srcPosition: Vector2(0, 0),
      srcSize: Vector2(32, 32),
    );
    sprite = tileFrame;

    propellorHitbox = RectangleHitbox(size: size)
      ..collisionType = CollisionType.passive;

    add(propellorHitbox);
  }
}
