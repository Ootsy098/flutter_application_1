import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/flame_game.dart';

void main() {
  onRestart();
}

void onRestart() {
  runApp(GameWidget(game: MyFirstFlameGame(onRestart: onRestart)));
}
