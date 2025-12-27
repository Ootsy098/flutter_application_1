import 'package:flame/components.dart';
import 'package:flutter_application_1/flame_game.dart';
import 'package:flutter_application_1/player.dart';
import 'package:flutter_application_1/player_strategies/player_strategy.dart';

abstract class PlatformState {
  late final SpriteComponent object;
  late final DoodleJump game;
  late final List<Vector2> framesPositions;
  late final List<Vector2> framesSizes;
  late final PlayerStrategy strategy;

  PlatformState(this.object, this.game);

  void onEnter();
  void animate(double dt);

  void executeStrategy(Player player) {
    strategy.execute(player, object);
  }
}
