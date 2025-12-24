import 'package:flame/components.dart';
import 'package:flutter_application_1/player.dart';

abstract class PlayerStrategy {
  void execute(Player player, PositionComponent other);
}
