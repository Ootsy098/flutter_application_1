import 'package:flutter_application_1/states/player_state.dart';

class NormalState extends PlayerState {
  late double gravityC = 1600;
  late bool firstJumpIsDone = false;
  double startJumpY = 0;

  NormalState(super.game, super.velocity, super.position, super.stateManager);

  @override
  void stateUpdate(double dt) {
    applyGravity(dt);
    if (!firstJumpIsDone && velocity.y >= 0 && startJumpY != 0) {
      firstJumpIsDone = true;
      final playerJumpDelta = startJumpY - position.y;
      game.maxPlatformGap = playerJumpDelta * 0.9;
    }
  }

  void applyGravity(double dt) {
    final cameraBottomY =
        game.camera.viewfinder.position.y + game.camera.viewport.size.y / 2;
    if (position.y < cameraBottomY) {
      velocity.y += gravityC * dt;
    } else {
      game.hud.onGameOver(game.playerScore.score);
      game.player.gameOver = true;
    }
  }

  void jump(double upwardsVelocity) {
    if (!firstJumpIsDone) {
      startJumpY = position.y;
    }
    velocity.y = upwardsVelocity;
  }
}
