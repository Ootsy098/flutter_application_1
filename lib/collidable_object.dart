import 'package:flame/components.dart';
import 'package:flutter_application_1/player.dart';

mixin CollidableObject on PositionComponent {
  late String collisionType;
  void executeStrategy(Player player);
}
