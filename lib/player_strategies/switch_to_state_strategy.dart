import 'package:flame/components.dart';
import 'package:flutter_application_1/player.dart';
import 'package:flutter_application_1/player_strategies/player_strategy.dart';

class SwitchToStateStrategy extends PlayerStrategy {
  final String state;

  SwitchToStateStrategy(this.state);

  @override
  void execute(Player player, PositionComponent other) {
    player.stateManager.switchState(state);
  }
}
