import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'junk_slash_game.dart';

enum PowerUpType { slowMotion, frenzy }

class PowerUpComponent extends PositionComponent with HasGameReference<JunkSlashGame> {
  final PowerUpType type;
  Vector2 velocity;
  static const double gravity = 900.0;
  late TextPainter textPainter;
  bool isSliced = false;

  PowerUpComponent({required super.position, required this.velocity, required this.type}) : super(size: Vector2(70, 70)) {
    anchor = Anchor.center;
    String emoji = type == PowerUpType.slowMotion ? '🧊' : '🔥'; // Buz (Yavaş Çekim), Ateş (Frenzy)
    textPainter = TextPainter(
      text: TextSpan(text: emoji, style: const TextStyle(fontSize: 60)),
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
    if (position.y > game.size.y + 100 && velocity.y > 0) {
      removeFromParent();
    }
  }

  void slice() {
    if (isSliced) return;
    isSliced = true;
    game.gameController.activatePowerUp(type);
    removeFromParent();
  }
}
