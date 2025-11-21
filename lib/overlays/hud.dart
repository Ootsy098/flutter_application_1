import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/flame_game.dart';

class Hud extends PositionComponent with HasGameReference<MyFirstFlameGame> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  });

  late TextComponent _scoreTextComponent;

  @override
  Future<void> onLoad() async {
    _scoreTextComponent = TextComponent(
      text: '${game.playerScore.score}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(10, 10, 10, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x / 2, 20),
    );
    add(_scoreTextComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _scoreTextComponent.text = game.playerScore.score.toString();
  }
}
