import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'junk_slash_game.dart';
import 'sliceable_piece.dart';
import 'audio_manager.dart';

class SliceableItem extends PositionComponent with HasGameReference<JunkSlashGame> {
  Vector2 velocity;
  final bool isBomb;
  final double gravity;
  bool isSliced = false;
  late String emoji;
  late TextPainter textPainter;

  SliceableItem({required super.position, required this.velocity, required this.isBomb, required Vector2 gameSize}) 
    : gravity = gameSize.y * 1.2, 
      super(size: Vector2.all(gameSize.y * 0.22)) {
    anchor = Anchor.center;
    final random = Random();
    if (isBomb) {
      final healthy = ['🥦', '🥑', '🍏', '🍎', '🍌', '🥕', '🍇', '🍓', '🍉', '🥗', '🍅'];
      emoji = healthy[random.nextInt(healthy.length)];
    } else {
      final unhealthy = ['🍟', '🍕', '🍩', '🌭', '🍫', '🍰', '🍭', '🥞', '🍿', '🍦']; // Hamburger (Joker) Çıkarıldı
      emoji = unhealthy[random.nextInt(unhealthy.length)];
    }

    textPainter = TextPainter(
      text: TextSpan(text: emoji, style: TextStyle(fontSize: gameSize.y * 0.16)),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPainter.paint(canvas, Offset(size.x / 2 - textPainter.width / 2, size.y / 2 - textPainter.height / 2));
  }

  @override
  void update(double dt) {
    if (isSliced) return;
    dt = dt * game.gameController.timeScale;
    super.update(dt);
    
    velocity.y += gravity * dt;
    position += velocity * dt;

    final screenHeight = game.size.y;
    if (position.y > screenHeight + size.y && velocity.y > 0) {
      if (!isBomb && !game.gameController.isGracePeriodActive) {
         game.gameController.loseLife();
      }
      removeFromParent();
    }
  }

  void slice({int multiplier = 1}) {
    if (isSliced) return;
    isSliced = true;

    if (isBomb) {
      HapticFeedback.heavyImpact();
      AudioManager.playSfx('deep explosion.mp3');
      game.gameController.punishBomb();
    } else {
      HapticFeedback.lightImpact();
      AudioManager.playSfx('squish.mp3');
      game.gameController.addScore(10, multiplier: multiplier);
    }
    
    // Create half pieces
    final leftPiece = SliceablePiece(
      position: position.clone() - Vector2(size.x * 0.2, 0),
      velocity: velocity.clone() + Vector2(-game.size.x * 0.15, -game.size.y * 0.05),
      isBomb: isBomb,
      isLeftPiece: true,
      emoji: emoji,
      gameSize: game.size,
    );
    final rightPiece = SliceablePiece(
      position: position.clone() + Vector2(size.x * 0.2, 0),
      velocity: velocity.clone() + Vector2(game.size.x * 0.15, -game.size.y * 0.05),
      isBomb: isBomb,
      isLeftPiece: false,
      emoji: emoji,
      gameSize: game.size,
    );
    game.add(leftPiece);
    game.add(rightPiece);

    // Particle effect
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 10,
        lifespan: 1.0,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, gravity),
          speed: (Vector2.random() - Vector2.all(0.5)) * 400,
          position: position.clone(),
          child: CircleParticle(
            radius: 4,
            paint: Paint()..color = isBomb ? Colors.greenAccent : Colors.orangeAccent,
          ),
        ),
      ),
    );
    game.add(particleComponent);

    removeFromParent();
  }
}
