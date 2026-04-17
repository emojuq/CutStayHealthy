import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'junk_slash_game.dart';

class SliceablePiece extends PositionComponent with HasGameReference<JunkSlashGame> {
  Vector2 velocity;
  final bool isBomb;
  final bool isLeftPiece;
  final String emoji;
  final double gravity;
  late double angularVelocity;
  late TextPainter textPainter;

  SliceablePiece({
    required super.position,
    required this.velocity,
    required this.isBomb,
    required this.isLeftPiece,
    required this.emoji,
    required Vector2 gameSize,
  }) : gravity = gameSize.y * 1.2, super(size: Vector2(gameSize.y * 0.11, gameSize.y * 0.22)) {
    anchor = Anchor.center;
    angularVelocity = (Random().nextDouble() - 0.5) * 10;

    textPainter = TextPainter(
      text: TextSpan(text: emoji, style: TextStyle(fontSize: gameSize.y * 0.16)),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.x, size.y));
    if (isLeftPiece) {
      textPainter.paint(canvas, Offset(0, size.y / 2 - textPainter.height / 2));
    } else {
      textPainter.paint(canvas, Offset(-textPainter.width / 2, size.y / 2 - textPainter.height / 2));
    }
    canvas.restore();
  }

  @override
  void update(double dt) {
    dt = dt * game.gameController.timeScale;
    super.update(dt);
    
    velocity.y += gravity * dt;
    position += velocity * dt;
    angle += angularVelocity * dt;

    final screenHeight = game.size.y;
    if (position.y > screenHeight + size.y && velocity.y > 0) {
      removeFromParent();
    }
  }
}
