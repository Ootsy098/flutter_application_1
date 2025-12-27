import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/flame_game.dart';
import 'package:flutter_application_1/pages/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(Key('home_page')),
    ),
  );
}

void onRestart() {
  runApp(GameWidget(game: DoodleJump(onRestart: onRestart)));
}
