import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_application_1/collidable_object.dart';

class Jetpack extends SpriteComponent implements CollidableObject {
  @override
  String collisionType = 'jetpack';
  late ShapeHitbox hitbox;
  late bool isEngaged;

  final List<Vector2> engageFrames = [
    Vector2(0, 0),
    Vector2(32, 0),
    Vector2(64, 0),
  ];

  final List<Vector2> blastFrames = [
    Vector2(96, 0),
    Vector2(0, 64),
    Vector2(32, 64),
  ];
  final List<Vector2> disengageFrames = [
    Vector2(64, 64),
    Vector2(96, 64),
    Vector2(0, 128),
  ];

  late double totalDuration;
  final double frameDuration = 0.1;
  late double timer = 0;
  late int engageFrameIndex = 0, blastFrameIndex = 0, disengageFrameIndex = 0;
  late final double endLoopTime = disengageFrames.length * frameDuration;
  late bool engageAnimationCompleted = false;

  Jetpack({super.position, required this.isEngaged, this.totalDuration = 0})
    : super(size: Vector2(32, 62), anchor: Anchor.center);

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
    if (isEngaged) {
      timer += dt;
      totalDuration -= dt;
      animate();
    }
  }

  void animate() {
    if (!engageAnimationCompleted) {
      animateEngage();
    } else if (totalDuration > endLoopTime) {
      animateBlast();
    } else {
      animateDisengage();
    }
  }

  void animateEngage() {
    if (engageFrameIndex < engageFrames.length - 1 && timer >= frameDuration) {
      timer = 0;
      engageFrameIndex++;
      Vector2 frame = engageFrames[engageFrameIndex];
      sprite!.srcPosition = frame;
      return;
    }
    engageAnimationCompleted = true;
  }

  void animateBlast() {
    if (isEngaged && timer >= frameDuration) {
      timer = 0;
      blastFrameIndex = (blastFrameIndex + 1) % engageFrames.length;
      Vector2 frame = blastFrames[blastFrameIndex];
      sprite!.srcPosition = frame;
    }
  }

  void animateDisengage() {
    if (disengageFrameIndex < disengageFrames.length - 1 &&
        timer >= frameDuration) {
      timer = 0;
      disengageFrameIndex++;
      Vector2 frame = disengageFrames[disengageFrameIndex];
      sprite!.srcPosition = frame;
    }
  }
}
