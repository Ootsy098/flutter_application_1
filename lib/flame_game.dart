import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/platform.dart';
import 'package:flutter_application_1/player.dart';

class MyFirstFlameGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late Player player;
  late List<RegularPlatform> platforms;
  MyFirstFlameGame({super.children});

  @override
  Color backgroundColor() {
    return Colors.white;
  }

  @override
  Future<void> onLoad() async {
    platforms = [];
    for (int i = 0; i < 5; i++) {
      platforms.add(
        RegularPlatform(
          position: Vector2(100.0 + i * 120, size.y - 150 - i * 50),
        ),
      );
    }
    for (final platform in platforms) {
      add(platform);
    }
    player = Player(
      position: Vector2(size.x / 2, size.y / 2),
      screenSize: size,
    );
    add(player);
  }
}
