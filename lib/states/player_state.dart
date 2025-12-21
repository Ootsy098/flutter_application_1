import 'package:flame/components.dart';
import 'package:flutter_application_1/flame_game.dart';
import 'package:flutter_application_1/states/player_state_manager.dart';

abstract class PlayerState {
  final MyFirstFlameGame game;
  final PlayerStateManager stateManager;
  final Vector2 velocity;
  final Vector2 position;
  void onStateEnter() {}
  void stateUpdate(double dt);

  PlayerState(this.game, this.velocity, this.position, this.stateManager);
}
