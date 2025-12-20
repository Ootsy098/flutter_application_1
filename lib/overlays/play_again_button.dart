import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter_application_1/flame_game.dart';

class PlayAgainButton extends PositionComponent
    with TapCallbacks, HasGameReference<MyFirstFlameGame> {
  PlayAgainButton({
    required this.buttonTextComponent,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 6,
  });

  late TextComponent buttonTextComponent;

  @override
  Future<void> onLoad() async {
    add(buttonTextComponent);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Handle button tap logic here
    super.onTapDown(event);
    game.overlays.remove('Hud');
    game.onRestart();
  }
}
