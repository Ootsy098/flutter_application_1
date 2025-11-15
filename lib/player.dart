import 'package:flame/components.dart';

const playerPNG = 'jumper_sprite.png';

class Player extends SpriteComponent {
  Player({super.position})
    : super(size: Vector2.all(100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(playerPNG);
  }
}
