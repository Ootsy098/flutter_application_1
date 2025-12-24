import 'package:flame/components.dart';
import 'package:flutter_application_1/player.dart';

mixin CollidableObject on PositionComponent {
  void executeStrategy(Player player);
}
