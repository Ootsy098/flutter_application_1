import 'package:flame/components.dart';
import 'package:flutter_application_1/player.dart';
import 'package:flutter_application_1/player_strategies/player_strategy.dart';
import 'package:flutter_application_1/states/normal_state.dart';

class JumpStrategy extends PlayerStrategy {
  late double jumpVelocity;
  late String label;
  JumpStrategy({required this.jumpVelocity, required this.label});
  @override
  void execute(Player player, PositionComponent other) {
    if (player.stateManager.activeState is NormalState) {
      if (label == 'spring') {
        (player.stateManager.activeState as NormalState).springJump(
          jumpVelocity,
        );
      } else {
        (player.stateManager.activeState as NormalState).jump(jumpVelocity);
      }
      player.enableJumpAnimation();
    }
  }
}
