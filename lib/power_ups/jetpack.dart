import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_application_1/collidable_object.dart';

class Jetpack extends SpriteComponent implements CollidableObject {
  @override
  String collisionType = 'jetpack';
  late ShapeHitbox hitbox;
  late bool isEngaged;

  final List<Vector2> frames = [
    Vector2(0, 0),
    Vector2(32, 0),
    Vector2(64, 0),
    Vector2(96, 0),

    Vector2(0, 32),
    Vector2(32, 32),
    Vector2(64, 32),
    Vector2(96, 32),
  ];

  final double frameDuration = 0.1;
  late double timer = 0;
  late int currentFrameIndex = 0;

  Jetpack({super.position, required this.isEngaged})
    : super(size: Vector2(32, 64), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Images().load("jetpack_animation.png");
    final tileFrame = Sprite(
      spriteSheet,
      srcPosition: Vector2(32, 128),
      srcSize: size,
    );
    sprite = tileFrame;

    if (!isEngaged) {
      hitbox = RectangleHitbox(size: Vector2(size.x, 32))
        ..collisionType = CollisionType.passive;
      add(hitbox);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer += dt;
    if (isEngaged && timer >= frameDuration) {
      timer = 0;
      currentFrameIndex = (currentFrameIndex + 1) % frames.length;
      Vector2 frame = frames[currentFrameIndex];
      sprite!.srcPosition = frame;
    }
  }
}
