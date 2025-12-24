import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_application_1/collidable_object.dart';

class Jetpack extends SpriteComponent implements CollidableObject {
  String collisionType = 'jetpack';
  late ShapeHitbox hitbox;
  late bool isEngaged;

  Jetpack({super.position, required this.isEngaged})
    : super(size: Vector2(20, 40), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Images().load("s");
    final tileFrame = Sprite(
      spriteSheet,
      srcPosition: Vector2(0, 0),
      srcSize: size,
    );
    sprite = tileFrame;

    if (isEngaged) {
      hitbox = RectangleHitbox(size: size)
        ..collisionType = CollisionType.passive;
      add(hitbox);
    }
  }
}
