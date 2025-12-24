import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_application_1/collidable_object.dart';
import 'package:flutter_application_1/flame_game.dart';
import 'package:flutter_application_1/player.dart';
import 'package:flutter_application_1/player_strategies/jump_strategy.dart';

class Spring extends SpriteComponent
    with HasGameReference<MyFirstFlameGame>
    implements CollidableObject {
  @override
  late String collisionType = 'spring';
  late ShapeHitbox springHitbox;
  late final JumpStrategy jumpStrategy;

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

    jumpStrategy = JumpStrategy(jumpVelocity: game.player.springJumpV);
  }

  @override
  void executeStrategy(Player player) {
    double tolerance = size.y / 2;
    if (player.velocity.y > 0 && player.position.y < position.y + tolerance) {
      jumpStrategy.execute(player, this);
    }
  }
}
