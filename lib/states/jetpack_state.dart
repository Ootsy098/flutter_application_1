import 'package:flame/components.dart';
import 'package:flutter_application_1/power_ups/jetpack.dart';
import 'package:flutter_application_1/states/player_state.dart';

class JetpackState extends PlayerState {
  late Jetpack jetpack;
  final double jetpackForce = 10000;
  final double jetpackDurationReset = 3;
  late double jetpackDuration;

  JetpackState(super.game, super.velocity, super.position, super.stateManager);

  @override
  void onStateEnter() {
    resetJetpackDuration();
    jetpack = Jetpack(isEngaged: true, totalDuration: jetpackDurationReset);
    game.camera.world?.add(jetpack);
  }

  @override
  void stateUpdate(double dt) {
    jetpackDuration -= dt;
    applyUpwardForce(dt);
    moveJetpack();
    if (jetpackDuration <= 0) {
      endJetpackState();
    }
  }

  void moveJetpack() {
    Vector2 jetpackOffset;
    double playerWidth = game.player.size.x;
    double jpWidth = jetpack.size.x;
    double offSetX = playerWidth / 2 - jpWidth / 2 + 5;
    if (game.player.lookingLeft) {
      jetpackOffset = Vector2(-offSetX, 10);
      if (jetpack.isFlippedHorizontally) {
        jetpack.flipHorizontally();
      }
    } else {
      jetpackOffset = Vector2(offSetX, 10);
      if (!jetpack.isFlippedHorizontally) {
        print('object');
        jetpack.flipHorizontally();
      }
    }
    jetpack.position = game.player.position - jetpackOffset;
  }

  void applyUpwardForce(double dt) {
    velocity.y = -jetpackForce * dt * 10;
  }

  void resetJetpackDuration() {
    jetpackDuration = jetpackDurationReset;
  }

  void endJetpackState() {
    jetpack.removeFromParent();
    stateManager.switchState('normal');
  }
}
