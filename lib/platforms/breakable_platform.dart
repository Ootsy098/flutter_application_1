import 'package:flame/extensions.dart';
import 'package:flutter_application_1/platforms/platform_state.dart';
import 'package:flutter_application_1/player.dart';

class BreakablePlatformState extends PlatformState {
  final List<Vector2> animationFramesPositions = [
    Vector2(1, 73),
    Vector2(0, 90),
    Vector2(0, 116),
    Vector2(0, 148),
  ];
  final List<Vector2> animationFramesSizes = [
    Vector2(60, 15),
    Vector2(60, 20),
    Vector2(60, 27),
    Vector2(60, 32),
  ];

  BreakablePlatformState(super.object, super.game) {
    framesPositions = animationFramesPositions;
    framesSizes = animationFramesSizes;
  }

  @override
  onEnter() {
    object.sprite!.srcPosition = framesPositions[0];
    object.sprite!.srcSize = framesSizes[0];
  }

  @override
  void animate() {}

  @override
  void executeStrategy(Player player) {
    animate();
    return;
  }
}
