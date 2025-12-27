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
  late TextComponent _pressSpaceComponent;
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
          fontSize: 48,
          color: Color.fromRGBO(0, 0, 0, 1),
          fontFamily: 'DoodleJump',
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x / 2, 20),
    );
    add(_scoreTextComponent);

    _pressSpaceComponent = TextComponent(
      text: 'Press Space to Start',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 50,
          color: Color.fromRGBO(0, 0, 0, 1),
          fontFamily: 'DoodleJump',
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x / 2, game.size.y / 4),
    );
    add(_pressSpaceComponent);
  }

  void onGameOver(int finalScore, int highScore) {
    game.soundManager.stopBackgroundMusic();

    _gameoverTextComponent = TextComponent(
      text: 'Game Over',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          color: Color.fromRGBO(0, 0, 0, 1),
          fontFamily: 'DoodleJump',
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

    _highScoreTextComponent = TextComponent(
      text: 'HighScore: $highScore',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          color: Color.fromRGBO(0, 0, 0, 1),
          fontFamily: 'DoodleJump',
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(game.size.x / 2, gameOverTextHeight + margin * 2),
    );

    _playAgainButtonComponent = PlayAgainButton(
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
    if (game.player.started) {
      _pressSpaceComponent.removeFromParent();
    }
    if (game.player.gameOver) return;
    _scoreTextComponent.text = game.playerScore.score.toString();
  }
}
