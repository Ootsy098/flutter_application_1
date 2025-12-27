import 'dart:math';
import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_application_1/collidable_object.dart';
import 'package:flutter_application_1/flame_game.dart';
import 'package:flutter_application_1/platforms/breakable_platform.dart';
import 'package:flutter_application_1/platforms/platform_state.dart';
import 'package:flutter_application_1/platforms/regular_platform_state.dart';
import 'package:flutter_application_1/player.dart';
import 'package:flutter_application_1/power_ups/jetpack.dart';
import 'package:flutter_application_1/power_ups/propellor.dart';
import 'package:flutter_application_1/spring.dart';

class Platform extends SpriteComponent
    with HasGameReference<DoodleJump>
    implements CollidableObject {
  late ShapeHitbox platformHitbox;
  late final hasSpringChance = 0.05;
  late final hasPropellorChance = 0.01;
  late final hasJetpackChance = 0.001;
  late SpriteComponent objectOnPlatform;
  late bool hasObject = false;
  late PlatformState currentState;
  final double breakablePlatformProbability = 0.3;

  final states = <String, PlatformState>{};

  Platform({super.position})
    : super(size: Vector2(80, 20), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final spriteSheet = await Images().load('tiles_spritesheet.png');
    final tileFrame = Sprite(
      spriteSheet,
      srcPosition: Vector2(1, 1),
      srcSize: Vector2(57, 15),
    );
    sprite = tileFrame;
    platformHitbox = RectangleHitbox(size: tileFrame.srcSize)
      ..collisionType = CollisionType.passive;
    add(platformHitbox);

    states['regular'] = RegularPlatformState(this, game);
    states['breakable'] = BreakablePlatformState(this, game);
    currentState = states['regular']!;
    currentState.onEnter();

    game.highestPlatformY = position.y;
    position.x = position.x.clamp(0 + size.x / 2, game.size.x - size.x / 2);
    checkIsBelowCam(0, 0);
    addObjectToPlatform();
  }

  @override
  void update(double dt) {
    currentState.animate(dt);
  }

  void checkIsBelowCam(double v, double dt) {
    double cameraBottomY =
        game.camera.viewfinder.position.y + game.camera.viewport.size.y / 2;
    bool isBelowCamera = position.y > cameraBottomY;
    if (isBelowCamera) {
      resetPosition();
    }
  }

  void resetPosition() {
    final rng = Random();
    position.x = rng.nextDouble() * (game.size.x - size.x) + size.x / 2;

    double distance = calculatePlatformGap(
      game.playerScore.score,
      game.minPlatformOriginalGap,
      game.maxPlatformGap,
    );
    position.y = game.highestPlatformY - distance;
    bool switchedToBreakable = switchState();
    if (!switchedToBreakable) {
      game.highestPlatformY = position.y;
    } else {
      game.highestPlatformY -= size.y * 1.5;
    }
    if (hasObject && objectOnPlatform.parent != null) {
      objectOnPlatform.removeFromParent();
      hasObject = false;
    }

    addObjectToPlatform();
  }

  bool switchState() {
    Random rng = Random();
    double randomNumber = rng.nextDouble();
    bool switchedToBreakable = false;
    if (randomNumber > breakablePlatformProbability) {
      currentState = states['regular']!;
    } else {
      currentState = states['breakable']!;
      switchedToBreakable = true;
    }
    currentState.onEnter();
    return switchedToBreakable;
  }

  void addObjectToPlatform() {
    if (currentState.runtimeType != RegularPlatformState) return;
    Random rng = Random();
    double randomNumber = rng.nextDouble();
    if (randomNumber > hasSpringChance) return;
    hasObject = true;
    double objectXOffset =
        (rng.nextDouble() * (size.x - 20)) - (size.x / 2 - 10);

    if (randomNumber <= hasJetpackChance) {
      objectOnPlatform = Jetpack(
        position: Vector2(position.x + objectXOffset, position.y - size.y / 2),
        isEngaged: false,
      );
    } else if (randomNumber <= hasPropellorChance) {
      objectOnPlatform = Propellor(
        position: Vector2(position.x + objectXOffset, position.y - size.y / 2),
        spinning: false,
      );
    } else if (randomNumber <= hasSpringChance) {
      objectOnPlatform = Spring(
        position: Vector2(position.x + objectXOffset, position.y - size.y / 2),
      );
    }

    game.camera.world?.add(objectOnPlatform);
  }

  static double calculatePlatformGap(
    int score,
    double minPlatformGap,
    double maxPossiblePlatformGap,
  ) {
    double gap = 0;
    double alteredMinGap = minPlatformGap;
    double alteredMaxGap = maxPossiblePlatformGap;
    Random rng = Random();

    switch (score) {
      case >= 0 && < 2000:
        alteredMaxGap *= 0.2;
        break;
      case >= 2000 && < 6000:
        alteredMaxGap *= 0.3;
        break;
      case >= 6000 && < 10000:
        alteredMaxGap *= 0.4;
        break;
      case >= 10000 && < 14000:
        alteredMinGap *= 1.3;
        alteredMaxGap *= 0.7;
        break;
      case >= 14000:
        alteredMinGap *= 1.5;
        alteredMaxGap *= 0.9;
        break;
      default:
        gap = 150;
    }
    gap = rng.nextDouble() * (alteredMaxGap - alteredMinGap) + alteredMinGap;
    return gap;
  }

  @override
  void executeStrategy(Player player) {
    currentState.executeStrategy(player);
  }
}
