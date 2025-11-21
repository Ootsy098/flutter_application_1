import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/overlays/hud.dart';
import 'package:flutter_application_1/overlays/player_score.dart';
import 'package:flutter_application_1/platform.dart';
import 'package:flutter_application_1/player.dart';

class MyFirstFlameGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late Player player;
  late List<RegularPlatform> platforms;
  late double maximumSpaceBetweenPlatforms;
  late double minSpaceBetweenPlatforms = 30;
  late double maxPlayerHeight = size.y / 2 - 50;
  late PlayerScore playerScore;
  MyFirstFlameGame({super.children});

  @override
  Color backgroundColor() {
    return Colors.white;
  }

  @override
  Future<void> onLoad() async {
    player = Player(
      position: Vector2(size.x / 2, size.y - 100),
      screenSize: size,
    );
    maximumSpaceBetweenPlatforms = player.normalJumpV.abs();

    playerScore = PlayerScore();

    platforms = [];
    for (int i = 0; i < size.y / minSpaceBetweenPlatforms; i++) {
      platforms.add(
        RegularPlatform(
          position: Vector2(
            Random().nextDouble() * size.x,
            i * size.y / (size.y / minSpaceBetweenPlatforms),
          ),
        ),
      );
    }
    for (final platform in platforms) {
      add(platform);
    }
    add(player);
    camera.viewport.add(Hud());
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    if (player.position.y < maxPlayerHeight) {
      playerScore.increaseScore(
        ((player.position.y - maxPlayerHeight)).toInt().abs(),
      );
      player.position.y = maxPlayerHeight;
      for (final platform in platforms) {
        platform.descendPlatform(player.velocity.y, dt, size.y);
      }
    }
  }
}
