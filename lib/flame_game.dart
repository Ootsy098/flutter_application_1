import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/background.dart';
import 'package:flutter_application_1/overlays/hud.dart';
import 'package:flutter_application_1/overlays/player_score.dart';
import 'package:flutter_application_1/platforms/platform.dart';
import 'package:flutter_application_1/player.dart';
import 'package:flutter_application_1/sound_manager.dart';

class MyFirstFlameGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late Player player = Player(
    position: Vector2(size.x / 2, size.y),
    screenSize: size,
  );
  late List<Platform> platforms;
  late Hud hud;
  final double minPlatformOriginalGap = 50;
  late double minPlatformGap = minPlatformOriginalGap;
  late double maxPlatformGap = 200;
  late double highestHeightReached = player.position.y;
  late double highestPlatformY;
  late PlayerScore playerScore;
  final VoidCallback onRestart;
  final SoundManager soundManager = SoundManager();
  int initialPlatformCount = 20;

  MyFirstFlameGame({required this.onRestart, super.children});

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 0, 0, 0);
  }

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: Vector2(500, size.y));

    loadGameComponents();

    add(Background());

    camera.viewfinder = Viewfinder();
    camera.viewfinder.position = Vector2(player.position.x, player.position.y);
    hud = Hud();
    camera.viewport.add(hud);
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    if (player.gameOver) return;

    if (player.position.y < highestHeightReached) {
      playerScore.increaseScore(
        (player.position.y - highestHeightReached).abs().toInt(),
      );
      highestHeightReached = player.position.y;
      camera.moveTo(
        Vector2(camera.viewfinder.position.x, highestHeightReached),
      );
      for (final platform in platforms) {
        platform.checkIsBelowCam(player.velocity.y, dt);
      }
    }
  }

  void loadGameComponents() {
    double playerX = size.x / 2;
    double playerY = size.y;
    player = Player(position: Vector2(playerX, playerY), screenSize: size);
    playerScore = PlayerScore();
    add(playerScore);

    platforms = [];
    double currentY =
        camera.viewfinder.position.y + camera.viewport.size.y * 1.5;

    for (int i = 0; i < initialPlatformCount; i++) {
      double gap = Platform.calculatePlatformGap(
        playerScore.score,
        minPlatformGap,
        maxPlatformGap,
      );
      Vector2 platformPos = Vector2(
        Random().nextDouble() * camera.viewport.size.x,
        currentY - gap,
      );
      platforms.add(Platform(position: platformPos));
      camera.world?.add(platforms.last);
      currentY -= gap;
    }

    camera.world?.add(player);
  }
}
