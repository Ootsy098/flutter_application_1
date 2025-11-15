import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Player.dart';

class MyFirstFlameGame extends FlameGame {
  MyFirstFlameGame({super.children});

  @override
  Color backgroundColor() {
    return Colors.green;
  }

  @override
  Future<void> onLoad() async {
    add(Player(position: Vector2(size.x / 2, size.y / 2)));
  }
}
