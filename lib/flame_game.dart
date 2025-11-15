import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/platform.dart';
import 'package:flutter_application_1/player.dart';

class MyFirstFlameGame extends FlameGame with HasKeyboardHandlerComponents {
  late Player player;
  late List<Platform> platforms;
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
    platforms = [];
    for (int i = 0; i < 5; i++) {
      platforms.add(
        Platform(position: Vector2(100.0 + i * 120, size.y - 150 - i * 50)),
      );
    }
    for (final platform in platforms) {
      add(platform);
    }
  }
}
