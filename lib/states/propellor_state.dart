import 'package:flame/game.dart';
import 'package:flutter_application_1/power_ups/propellor.dart';
import 'package:flutter_application_1/states/player_state.dart';

class PropellorState extends PlayerState {
  late Propellor propellor;
  final double propellorForce = 6000;
  final double propellorDurationReset = 2.7;
  late double propellorDuration;

  PropellorState(
    super.game,
    super.velocity,
    super.position,
    super.stateManager,
  );

  @override
  void onStateEnter() {
    resetPropellorDuration();
    propellor = Propellor(spinning: true);
    game.camera.world?.add(propellor);
  }

  @override
  void stateUpdate(double dt) {
    propellorDuration -= dt;
    applyUpwardForce(dt);
    movePropellorHat();
    if (propellorDuration <= 0) {
      endPropellorState();
    }
  }

  void movePropellorHat() {
    Vector2 propellorOffset;
    if (game.player.lookingLeft) {
      propellorOffset = Vector2(-7, game.player.size.y - 10);
    } else {
      propellorOffset = Vector2(7, game.player.size.y - 10);
    }
    propellor.position = game.player.position - propellorOffset;
  }

  void applyUpwardForce(double dt) {
    velocity.y = -propellorForce * dt * 10;
  }

  void resetPropellorDuration() {
    propellorDuration = propellorDurationReset;
  }

  void endPropellorState() {
    game.camera.world?.remove(propellor);
    stateManager.switchState('normal');
  }
}
