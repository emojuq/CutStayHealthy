import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'junk_slash_game.dart';
import 'floating_text.dart';
import 'audio_manager.dart';

class JokerItem extends PositionComponent with HasGameReference<JunkSlashGame> {
  Vector2 velocity;
  int hits = 0;
  final int maxHits = 25;
  late TextPainter textPainter;
  final Random _random = Random();
  Vector2 targetPosition = Vector2.zero();
  double speed = 120.0;

  JokerItem({required super.position, required this.velocity}) : super(size: Vector2(150, 150)) {
    anchor = Anchor.center;
    textPainter = TextPainter(
      text: const TextSpan(text: '🍔', style: TextStyle(fontSize: 120)),
      textDirection: TextDirection.ltr,
    )..layout();
  }
  
  @override
  void onLoad() {
    super.onLoad();
    _pickNewTarget();
  }

  void _pickNewTarget() {
    double sx = game.size.x;
    double sy = game.size.y;
    targetPosition = Vector2(
      80 + _random.nextDouble() * (sx - 160),
      80 + _random.nextDouble() * (sy - 160),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPainter.paint(canvas, Offset(size.x / 2 - textPainter.width / 2, size.y / 2 - textPainter.height / 2));
  }

  @override
  void update(double dt) {
    dt = dt * game.gameController.timeScale;
    super.update(dt);
    
    if (position.distanceTo(targetPosition) < 30) {
      _pickNewTarget();
    }
    velocity = (targetPosition - position).normalized() * speed;
    position += velocity * dt;
  }

  void receiveHit() {
    hits++;
    HapticFeedback.heavyImpact();
    AudioManager.playSfx('cash register.mp3');
    game.gameController.addScore(5);
    
    game.add(ParticleSystemComponent(
      particle: Particle.generate(
        count: 8,
        lifespan: 0.8,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 500),
          speed: (Vector2.random() - Vector2.all(0.5)) * 400,
          position: position.clone(),
          child: CircleParticle(
            radius: 4,
            paint: Paint()..color = Colors.orangeAccent,
          ),
        ),
      ),
    ));

    game.add(FloatingText(
      text: '+$hits HITS',
      position: position.clone() + Vector2(0, -60),
      color: Colors.pinkAccent,
    ));

    if (hits >= maxHits) {
      game.gameController.addScore(250); // Dev ödül
      game.add(FloatingText(
        text: 'PERFECT COMBO!',
        position: position.clone(),
        color: Colors.amber,
        scale: 2.0,
      ));
      removeFromParent();
    }
  }
}
