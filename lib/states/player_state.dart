import 'package:flutter_application_1/states/normal_state.dart';
import 'package:flutter_application_1/states/propellor_state.dart';

abstract class PlayerState {
  final states = <String, PlayerState>{
    'normalState': NormalState(),
    'propellorState': PropellorState(),
  };
  PlayerState activeState = NormalState();

  void switchState(String state) {
    final newState = states[state];
    if (newState == null) {
      throw ArgumentError('Unknown state: $state');
    }
    activeState = newState;
  }

  void stateUpdate();
}
