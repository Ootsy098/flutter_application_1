import 'package:flame/extensions.dart';
import 'package:flutter_application_1/platforms/platform_state.dart';
import 'package:flutter_application_1/player.dart';

class BreakablePlatformState extends PlatformState {
  final double platformGravityC = 700;
  late bool isBroken = false;
  late double animationTimer = 0;
  late double animationSpeed = 0.05;
  int currentFrameIndex = 0;

  BreakablePlatformState(super.object, super.game) {
    framesPositions = [
      Vector2(1, 73),
      Vector2(0, 90),
      Vector2(0, 116),
      Vector2(0, 148),
    ];
    framesSizes = [
      Vector2(60, 15),
      Vector2(62, 20),
      Vector2(62, 27),
      Vector2(62, 32),
    ];
  }

  @override
  void onEnter() {
    object.sprite!.srcPosition = framesPositions[0];
    object.sprite!.srcSize = framesSizes[0];
    isBroken = false;
    currentFrameIndex = 0;
    animationTimer = 0;
  }

  @override
  void animate(double dt) {
    if (!isBroken) return;

    animationTimer += dt;
    if (currentFrameIndex < framesPositions.length - 1 &&
        animationTimer > animationSpeed) {
      object.sprite!.srcPosition = framesPositions[currentFrameIndex];
      object.sprite!.srcSize = framesSizes[currentFrameIndex];
      animationTimer = 0;
      currentFrameIndex++;
    }
    object.position.y += platformGravityC * dt;
  }

  @override
  void executeStrategy(Player player) {
    double tolerance = object.size.y / 2;
    if (player.velocity.y > 0 &&
        player.position.y < object.position.y + tolerance) {
      isBroken = true;
    }
    return;
  }
}
