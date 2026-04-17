import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'junk_slash_game.dart';
import 'spawner_component.dart';
import 'game_mode_manager.dart';
import 'powerup_component.dart';
import 'sliceable_item.dart';

class GameController extends Component with HasGameReference<JunkSlashGame> {
  static int totalGameOverCount = 0;
  
  final GameModeManager modeManager;
  int score = 0;
  int lives = 3;
  double timeLeft = 60.0;
  double stamina = 100.0;
  bool isGameOver = false;
  bool hasStarted = false; // Oyun "Nasıl Oynanır" ekranından sonra başlayacak
  bool hasUsedRewardedAd = false;
  double timeScale = 1.0;

  final ValueNotifier<int> scoreNotifier = ValueNotifier(0);
  final ValueNotifier<int> livesNotifier = ValueNotifier(3);
  final ValueNotifier<int> timeNotifier = ValueNotifier(60);
  final ValueNotifier<double> staminaNotifier = ValueNotifier(100.0);
  final ValueNotifier<int> frenzyNotifier = ValueNotifier(0);

  GameController(GameMode mode) : modeManager = GameModeManager(mode);

  late Timer slowMoTimer;
  late Timer frenzyTimer;
  late Timer powerupGraceTimer;
  bool isFrenzyActive = false;

  @override
  void onLoad() {
    slowMoTimer = Timer(3.0, onTick: _endSlowMo, autoStart: false);
    frenzyTimer = Timer(5.0, onTick: _endFrenzy, autoStart: false);
    powerupGraceTimer = Timer(0.0, autoStart: false);
  }

  bool get isGracePeriodActive => powerupGraceTimer.isRunning();

  @override
  void update(double dt) {
    if (isGameOver || !hasStarted) return;
    
    slowMoTimer.update(dt);
    frenzyTimer.update(dt);
    powerupGraceTimer.update(dt);
    
    // Hız modunda zaman geçtikçe base time scale artar
    double baseScale = 1.0;
    if (modeManager.hasTimer) {
      double elapsed = 60.0 - timeLeft;
      baseScale = 1.0 + (log(elapsed + 1) / 8.0);
    }
    
    timeScale = slowMoTimer.isRunning() ? 0.3 : baseScale;

    if (frenzyTimer.isRunning()) {
      frenzyNotifier.value = (5.0 - frenzyTimer.progress * 5.0).ceil();
    } else {
      frenzyNotifier.value = 0;
    }

    if (modeManager.hasTimer) {
      timeLeft -= dt;
      timeNotifier.value = timeLeft.ceil();
      if (timeLeft <= 0) {
        gameOver();
      }
    } else if (modeManager.hasStamina) {
      stamina -= dt * 3; // Erodes passively
      stamina = stamina.clamp(0.0, 100.0);
      staminaNotifier.value = stamina;
      if (stamina <= 0) {
        gameOver();
      }
    }
  }

  void addScore(int points, {int multiplier = 1}) {
    if (isGameOver) return;
    score += (points * multiplier);
    scoreNotifier.value = score;
    if (modeManager.hasStamina) {
      stamina = (stamina + 5.0).clamp(0.0, 100.0);
    }
  }

  void punishBomb() {
    if (isGameOver) return;
    if (modeManager.hasLives) {
      gameOver();
    } else if (modeManager.hasTimer) {
      score = (score - 20).clamp(0, 99999);
      scoreNotifier.value = score;
    } else if (modeManager.hasStamina) {
      stamina = (stamina - 20.0).clamp(0.0, 100.0);
    }
  }

  void loseLife() {
    if (isGameOver) return;
    
    if (modeManager.hasLives) {
      lives -= 1;
      livesNotifier.value = lives;
      if (lives <= 0) {
        gameOver();
      }
    } else if (modeManager.hasStamina) {
      stamina = (stamina - 15.0).clamp(0.0, 100.0);
    }
  }

  void activatePowerUp(PowerUpType type) {
    if (type == PowerUpType.slowMotion) {
      timeScale = 0.3;
      slowMoTimer.start();
      powerupGraceTimer = Timer(8.0)..start(); // 3s aktif + 5s koruma
      try {
        final spawner = game.children.whereType<SpawnerComponent>().firstOrNull;
        spawner?.spawnBurst(15);
      } catch (e) {}
      game.children.whereType<SliceableItem>().forEach((item) {
        if (item.isBomb) item.removeFromParent();
      });
    } else if (type == PowerUpType.frenzy) {
      isFrenzyActive = true;
      frenzyTimer.start();
      powerupGraceTimer = Timer(10.0)..start(); // 5s aktif + 5s koruma
      game.children.whereType<SliceableItem>().forEach((item) {
        if (item.isBomb) item.removeFromParent();
      });
    }
  }

  void _endSlowMo() {
    // timeScale dinamik olarak ayarlandığı için burada bir şey yapmaya gerek yok
  }

  void _endFrenzy() {
    isFrenzyActive = false;
  }

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    totalGameOverCount++;
    _endSlowMo();
    game.overlays.add('GameOver');
  }

  void revive() {
    if (modeManager.hasLives) {
      lives = 3;
      livesNotifier.value = lives;
    }
    hasUsedRewardedAd = true;
    isGameOver = false;
    // Activate a temporary grace period so player doesn't die instantly upon revive
    powerupGraceTimer = Timer(3.0)..start();
    game.overlays.remove('GameOver');
  }
}
