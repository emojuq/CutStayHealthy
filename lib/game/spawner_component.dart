import 'dart:math';
import 'package:flame/components.dart';
import 'junk_slash_game.dart';
import 'sliceable_item.dart';
import 'powerup_component.dart';
import 'joker_item.dart';

class SpawnerComponent extends Component with HasGameReference<JunkSlashGame> {
  late Timer spawnerTimer;
  final Random _random = Random();
  double baseSpawnTime = 1.2; // EKRANDA DAHA ÇOK NESNE (Önceki 1.5 idi)
  bool jokerSpawned = false;

  @override
  void onLoad() {
    _startTimer(baseSpawnTime);
  }

  void _startTimer(double duration) {
    spawnerTimer = Timer(
      duration,
      onTick: spawnItem,
      repeat: true,
    );
  }

  @override
  void update(double dt) {
    if (!game.gameController.isGameOver && game.gameController.hasStarted) {
      dt = dt * game.gameController.timeScale;
      spawnerTimer.update(dt);
      
      if (game.gameController.isFrenzyActive) {
         if (_random.nextDouble() < 0.1) {
            spawnFrenzyItem();
         }
      }
    }
  }

  void spawnBurst(int count) {
    for (int i = 0; i < count; i++) {
      spawnItem(forceUnhealthy: true);
    }
  }

  void spawnItem({bool forceUnhealthy = false}) {
    final double screenWidth = game.size.x;
    final double screenHeight = game.size.y;

    int side = _random.nextInt(3);
    double startX, startY, vX, targetHeight;
    final double g = screenHeight * 1.2; // dynamic gravity

    if (side == 0) {
      // Spawn from bottom
      startX = (screenWidth * 0.15) + _random.nextDouble() * (screenWidth * 0.7);
      startY = screenHeight + (screenHeight * 0.1);
      targetHeight = screenHeight * (0.6 + _random.nextDouble() * 0.3); // 60% to 90% of screen
      
      // Aim towards the center
      if (startX < screenWidth * 0.5) {
        vX = screenWidth * 0.1 + _random.nextDouble() * (screenWidth * 0.2); // Push Right
      } else {
        vX = -screenWidth * 0.1 - _random.nextDouble() * (screenWidth * 0.2); // Push Left
      }
    } else if (side == 1) { // Left
      startX = -screenHeight * 0.1;
      startY = screenHeight * 0.5 + _random.nextDouble() * (screenHeight * 0.4);
      targetHeight = startY * 0.8;
      vX = screenWidth * 0.3 + _random.nextDouble() * (screenWidth * 0.3); // Push Right
    } else { // Right
      startX = screenWidth + screenHeight * 0.1;
      startY = screenHeight * 0.5 + _random.nextDouble() * (screenHeight * 0.4);
      targetHeight = startY * 0.8;
      vX = -screenWidth * 0.3 - _random.nextDouble() * (screenWidth * 0.3); // Push Left
    }

    final vY = -sqrt(2 * g * targetHeight);

    if (_random.nextDouble() < 0.05 && !game.gameController.isFrenzyActive) {
      bool isSlowMo = _random.nextBool();
      game.add(PowerUpComponent(
        position: Vector2(startX, startY),
        velocity: Vector2(vX, vY),
        type: isSlowMo ? PowerUpType.slowMotion : PowerUpType.frenzy,
      ));
      return; // Skip normal item
    }

    if (!jokerSpawned && _random.nextDouble() < 0.03) { // %3 ihtimalle her oyunda 1 kerelik dev joker eklensin
      jokerSpawned = true;
      game.add(JokerItem(
        position: Vector2(screenWidth / 2, -150),
        velocity: Vector2((_random.nextDouble() - 0.5) * 50, 60), // Yavaşça aşağı iner
      ));
      return;
    }

    bool isBomb = _random.nextDouble() < 0.2;
    if (forceUnhealthy || game.gameController.isGracePeriodActive) {
       isBomb = false;
    }
    
    final item = SliceableItem(
      position: Vector2(startX, startY),
      velocity: Vector2(vX, vY),
      isBomb: isBomb,
      gameSize: game.size,
    );

    game.add(item);
  }

  void spawnFrenzyItem() {
     final double screenWidth = game.size.x;
     final double screenHeight = game.size.y;
     
     double startX = _random.nextBool() ? -screenHeight * 0.1 : screenWidth + screenHeight * 0.1;
     double startY = _random.nextBool() ? -screenHeight * 0.1 : screenHeight + screenHeight * 0.1;
     
     double vX = startX < 0 ? screenWidth * 0.2 + _random.nextDouble() * (screenWidth * 0.2) : -screenWidth * 0.2 - _random.nextDouble() * (screenWidth * 0.2);
     double vY = startY < 0 ? screenHeight * 0.2 + _random.nextDouble() * (screenHeight * 0.3) : -screenHeight * 0.6 - _random.nextDouble() * (screenHeight * 0.3);
     
     final item = SliceableItem(
        position: Vector2(startX, startY),
        velocity: Vector2(vX, vY),
        isBomb: false,
        gameSize: game.size,
     );
     game.add(item);
  }
}
