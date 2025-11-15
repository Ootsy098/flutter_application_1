import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/player.dart';

class MyFirstFlameGame extends FlameGame with HasKeyboardHandlerComponents {
  late Player player;
  MyFirstFlameGame({super.children});

  @override
  Color backgroundColor() {
    return Colors.green;
  }

  @override
  Future<void> onLoad() async {
    player = Player(
      position: Vector2(size.x / 2, size.y / 2),
      screenSize: size,
    );
    add(player);
  }
}
