import 'package:flutter_application_1/states/player_state.dart';

class PropellorState extends PlayerState {
  final double propellorForce = 6000;
  late double propellorDuration = 2.7;
  PropellorState(
    super.game,
    super.velocity,
    super.position,
    super.stateManager,
  );

  @override
  void stateUpdate(double dt) {
    propellorDuration -= dt;
    applyUpwardForce(dt);
    if (propellorDuration <= 0) {
      endPropellorState();
    }
  }

  void applyUpwardForce(double dt) {
    velocity.y = -propellorForce * dt * 10;
  }

  void resetPropellorDuration() {
    propellorDuration = 3;
  }

  void endPropellorState() {
    resetPropellorDuration();
    stateManager.switchState('normal');
  }
}
