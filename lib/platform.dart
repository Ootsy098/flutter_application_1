import 'package:flame/cache.dart';
import 'package:flame/components.dart';

class Platform extends SpriteComponent {
  Platform({super.position})
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
  }
}
