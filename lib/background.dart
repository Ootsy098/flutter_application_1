import 'dart:developer';
import 'package:flame/components.dart';
import 'package:flutter_application_1/flame_game.dart';

class Background extends SpriteComponent
    with HasGameReference<MyFirstFlameGame> {
  Background({super.position})
    : super(size: Vector2.zero(), anchor: Anchor.topCenter);

  final String spriteString = 'background.png';
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(spriteString);
    size = game.size;
    double windowWidth = game.camera.viewport.size.x;
    double midWindowX = game.camera.viewport.position.x;
    position.x = midWindowX + windowWidth / 2;
    log(windowWidth.toString());
  }
}
