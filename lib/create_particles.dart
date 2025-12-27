import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/flame_game.dart';

class CreateParticles {
  static void createJumpParticleEffect(
    Vector2 position,
    Color color,
    int count,
    MyFirstFlameGame game,
  ) {
    final particleSystem = ParticleSystemComponent(
      particle: Particle.generate(
        count: count,
        lifespan: 0.3,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 200),
          speed: CreateParticles.calculateSpeed(i, count),
          position: Vector2.zero(),
          child: CircleParticle(radius: 2, paint: Paint()..color = color),
        ),
      ),
    );
    particleSystem.position = position;
    game.camera.world?.add(particleSystem);
  }

  static Vector2 calculateSpeed(int i, int totalParticles) {
    final rng = Random();

    final double angleDeg = i.isEven
        ? rng.nextDouble() * 90
        : 270 + rng.nextDouble() * 90;

    final double angleRad = angleDeg * pi / 180;

    final int direction = i.isEven ? 1 : -1;
    final double speed = 150 + rng.nextDouble() * 100;

    final double speedX = cos(angleRad) * speed * direction;
    final double speedY = sin(angleRad) * speed * -1;

    return Vector2(speedX, speedY);
  }
}
