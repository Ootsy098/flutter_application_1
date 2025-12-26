import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter_application_1/flame_game.dart';

class PlayAgainButton extends SpriteComponent
    with TapCallbacks, HasGameReference<MyFirstFlameGame> {
  PlayAgainButton({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 6,
  });

  @override
  Future<void> onLoad() async {
    final image = await game.images.load('play_again_hover.png');
    sprite = Sprite(image);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    game.overlays.remove('Hud');
    game.onRestart();
  }
}
