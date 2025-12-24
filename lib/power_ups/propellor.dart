import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_application_1/collidable_object.dart';
import 'package:flutter_application_1/player.dart';
import 'package:flutter_application_1/player_strategies/switch_to_state_strategy.dart';

class Propellor extends SpriteComponent implements CollidableObject {
  @override
  late String collisionType = 'propellor';
  late ShapeHitbox propellorHitbox;
  late bool spinning;
  final SwitchToStateStrategy switchToPropellorStateStrategy =
      SwitchToStateStrategy('propellor');

  final List<Vector2> frames = [
    Vector2(32, 0),
    Vector2(0, 32),
    Vector2(32, 32),
  ];
  final double frameDuration = 0.1;
  late double timer = 0;
  late int currentFrameIndex = 0;

  Propellor({super.position, required this.spinning})
    : super(size: Vector2(32, 32), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Images().load('propellor_animation.png');
    final tileFrame = Sprite(
      spriteSheet,
      srcPosition: Vector2(0, 0),
      srcSize: size,
    );
    sprite = tileFrame;

    if (!spinning) {
      propellorHitbox = RectangleHitbox(size: size)
        ..collisionType = CollisionType.passive;

      add(propellorHitbox);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer += dt;
    if (spinning && timer >= frameDuration) {
      timer = 0;
      currentFrameIndex = (currentFrameIndex + 1) % frames.length;
      Vector2 frame = frames[currentFrameIndex];
      sprite!.srcPosition = frame;
    }
  }

  @override
  void executeStrategy(Player player) {
    switchToPropellorStateStrategy.execute(player, this);
    removeFromParent();
  }
}
