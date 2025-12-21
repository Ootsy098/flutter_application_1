import 'package:flutter_application_1/flame_game.dart';
import 'package:flutter_application_1/player.dart';
import 'package:flutter_application_1/states/normal_state.dart';
import 'package:flutter_application_1/states/player_state.dart';
import 'package:flutter_application_1/states/propellor_state.dart';

class PlayerStateManager {
  final MyFirstFlameGame game;
  final Player player;
  final states = <String, PlayerState>{};
  late PlayerState activeState;

  PlayerStateManager(this.game, this.player) {
    states['normal'] = NormalState(
      game,
      player.velocity,
      player.position,
      this,
    );
    states['propellor'] = PropellorState(
      game,
      player.velocity,
      player.position,
      this,
    );
    activeState = states['normal']!;
  }

  void switchState(String state) {
    final newState = states[state];
    if (newState == null) {
      throw ArgumentError('Unknown state: $state');
    }
    activeState = newState;
  }
}
