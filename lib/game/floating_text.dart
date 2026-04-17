import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FloatingText extends TextComponent {
  final Vector2 moveVector = Vector2(0, -100);
  double lifespan = 1.0;

  FloatingText({required String text, required Vector2 position, Color color = Colors.white, double scale = 1.0})
      : super(
          text: text,
          position: position,
          textRenderer: TextPaint(
            style: TextStyle(
              color: color,
              fontSize: 24 * scale,
              fontWeight: FontWeight.bold,
              shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ) {
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += moveVector * dt;
    lifespan -= dt;
    if (lifespan <= 0) {
      removeFromParent();
    }
  }
}
