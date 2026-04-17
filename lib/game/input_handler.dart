import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'junk_slash_game.dart';
import 'sliceable_item.dart';
import 'combo_system.dart';
import 'powerup_component.dart';
import 'shop_and_storage.dart';
import 'package:flutter/services.dart';
import 'floating_text.dart';
import 'joker_item.dart';
import 'audio_manager.dart';

class InputHandler extends Component with HasGameReference<JunkSlashGame> {
  final List<Vector2> trace = [];
  static const int maxTraceLength = 10;
  final ComboSystem comboSystem = ComboSystem();
  
  void onPanStart(DragStartInfo info) {
    trace.clear();
    trace.add(info.eventPosition.global);
    AudioManager.playSfx('swoosh.mp3');
    comboSystem.reset();
  }

  void onPanUpdate(DragUpdateInfo info) {
    trace.add(info.eventPosition.global);
    if (trace.length > maxTraceLength) {
      trace.removeAt(0);
    }
    
    _checkCollisions();
  }

  void onPanEnd(DragEndInfo info) {
    trace.clear();
    comboSystem.reset();
  }

  void _checkCollisions() {
    if (trace.length > 1) {
      final p2 = trace.last;
      
      final items = game.children.whereType<SliceableItem>().toList();
      for (final item in items) {
        if (!item.isSliced) {
          if (item.toRect().contains(p2.toOffset())) {
            comboSystem.registerSlice(DateTime.now().millisecondsSinceEpoch / 1000.0);
            item.slice(multiplier: comboSystem.multiplier);
            if (comboSystem.isComboActive) {
                HapticFeedback.mediumImpact();
                AudioManager.playSfx('ting.mp3');
                game.add(FloatingText(text: 'KUSURSUZ! x${comboSystem.multiplier}', position: p2.clone() - Vector2(0, 30)));
            }
          }
        }
      }

      final powerups = game.children.whereType<PowerUpComponent>().toList();
      for (final p in powerups) {
         if (!p.isSliced) {
            if (p.toRect().contains(p2.toOffset())) {
                p.slice();
            }
         }
      }

      final jokers = game.children.whereType<JokerItem>().toList();
      for (final j in jokers) {
          if (j.toRect().contains(p2.toOffset())) {
              j.receiveHit();
              trace.clear(); // Vurulduktan hemen sonra yeni hit için kesmeyi resetle
              break; // Aynı frame de birden fazla tespit olmasın
          }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (trace.length > 1) {
      var trailColor = ShopAndStorage.equippedTrail == 'Neon Yeşil' ? Colors.greenAccent :
                       ShopAndStorage.equippedTrail == 'Ateş Rengi' ? Colors.deepOrangeAccent :
                       Colors.white; 

      final paint = Paint()
        ..color = trailColor
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
        
      for (int i = 0; i < trace.length - 1; i++) {
        canvas.drawLine(trace[i].toOffset(), trace[i + 1].toOffset(), paint);
      }
    }
  }
}
