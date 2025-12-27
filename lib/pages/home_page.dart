import 'package:flutter/material.dart';
import 'package:flutter_application_1/flame_game.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flame/game.dart';

class HomePage extends StatelessWidget {
  const HomePage(Key? key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Project')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GamePage(Key('game_page'))),
            );
          },
          child: Text('Launch Game'),
        ),
      ),
    );
  }
}

class GamePage extends StatelessWidget {
  const GamePage(Key? key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: DoodleJump(onRestart: onRestart)),
    );
  }
}
