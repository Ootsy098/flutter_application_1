import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/flame_game.dart';
import 'package:flutter_application_1/overlays/play_again_button.dart';

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

  late TextComponent _gameoverTextComponent;
  late TextComponent _highScoreTextComponent;
  late PlayAgainButton _playAgainButtonComponent;

  double gameOverTextHeight = 48;
  double margin = 50;

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

  void onGameOver(int finalScore) {
    _gameoverTextComponent = TextComponent(
      text: 'Game Over',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          color: Color.fromRGBO(255, 0, 0, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x / 2, gameOverTextHeight),
    );

    _scoreTextComponent.text = 'Final Score: $finalScore';
    _scoreTextComponent.position = Vector2(
      game.size.x / 2,
      gameOverTextHeight + margin,
    );
    _scoreTextComponent.textRenderer = TextPaint(
      style: const TextStyle(fontSize: 48, color: Color.fromRGBO(255, 0, 0, 1)),
    );

    _highScoreTextComponent = TextComponent(
      text: 'HighScore: $finalScore',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          color: Color.fromRGBO(255, 0, 0, 1),
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x / 2, gameOverTextHeight + margin * 2),
    );

    _playAgainButtonComponent = PlayAgainButton(
      buttonTextComponent: TextComponent(
        text: 'Play Again',
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 32,
            color: Color.fromRGBO(0, 0, 255, 1),
            backgroundColor: Colors.red,
          ),
        ),
        anchor: Anchor.topLeft,
      ),
      position: Vector2(game.size.x / 2, game.size.y - margin * 3),
      size: Vector2(200, 60),
      anchor: Anchor.center,
    );

    add(_gameoverTextComponent);
    add(_highScoreTextComponent);
    add(_playAgainButtonComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.player.gameOver) return;
    _scoreTextComponent.text = game.playerScore.score.toString();
  }
}
