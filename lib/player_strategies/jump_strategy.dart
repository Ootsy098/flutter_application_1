import 'package:flame/components.dart';
import 'package:flutter_application_1/player.dart';
import 'package:flutter_application_1/player_strategies/player_strategy.dart';
import 'package:flutter_application_1/states/normal_state.dart';

class JumpStrategy extends PlayerStrategy {
  final double jumpVelocity;
  JumpStrategy({required this.jumpVelocity});
  @override
  void execute(Player player, PositionComponent other) {
    if (player.stateManager.activeState is NormalState) {
      (player.stateManager.activeState as NormalState).jump(jumpVelocity);
      player.enableJumpAnimation();
    }
  }
}
