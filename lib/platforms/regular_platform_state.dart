import 'package:flame/components.dart';
import 'package:flutter_application_1/platforms/platform_state.dart';
import 'package:flutter_application_1/player_strategies/jump_strategy.dart';

class RegularPlatformState extends PlatformState {
  int currentFrameIndex = 0;
  double animationTimer = 0.0;
  final double animationSpeed = 0.2;

  RegularPlatformState(super.object, super.game) {
    strategy = JumpStrategy(jumpVelocity: 0);
    framesPositions = [Vector2(1, 1)];
    framesSizes = [Vector2(57, 15)];
  }

  @override
  void onEnter() {
    (strategy as JumpStrategy).jumpVelocity = game.player.normalJumpV;
    object.sprite!.srcPosition = framesPositions[0];
    object.sprite!.srcSize = framesSizes[0];
  }

  @override
  void animate(double dt) {
    return;
  }

  @override
  void executeStrategy(player) {
    double tolerance = object.size.y / 2;
    if (player.velocity.y > 0 &&
        player.position.y < object.position.y + tolerance) {
      strategy.execute(player, object);
    }
  }
}
