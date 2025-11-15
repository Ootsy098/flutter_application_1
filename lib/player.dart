import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const String playerPNG = 'jumper_sprite.png';

class Player extends SpriteComponent with KeyboardHandler {
  num playerSpeed = 10;
  late Set<LogicalKeyboardKey> keysDown = {};
  final Vector2 screenSize;

  Player({super.position, required this.screenSize})
    : super(size: Vector2.all(100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(playerPNG);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      keysDown.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      keysDown.remove(event.logicalKey);
    }

    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (keysDown.contains(LogicalKeyboardKey.arrowLeft)) {
      move(-1);
    } else if (keysDown.contains(LogicalKeyboardKey.arrowRight)) {
      move(1);
    }
  }

  void move(int dir) {
    position.x += dir * playerSpeed;

    if (position.x < -size.x / 2) {
      position.x = screenSize.x + size.x / 2;
    } else if (position.x > screenSize.x + size.x / 2) {
      position.x = -size.x / 2;
    }
  }
}
