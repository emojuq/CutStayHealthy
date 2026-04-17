import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/camera.dart';
import 'package:flutter/material.dart';

import 'game_controller.dart';
import 'game_mode_manager.dart';
import 'spawner_component.dart';
import 'input_handler.dart';

class JunkSlashGame extends FlameGame with PanDetector {
  final GameMode initialMode;
  late final GameController gameController;
  late final InputHandler inputHandler;

  JunkSlashGame({this.initialMode = GameMode.classic}) : super() {
    gameController = GameController(initialMode);
    inputHandler = InputHandler();
  }

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    add(gameController);
    add(SpawnerComponent());
    add(inputHandler);
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (!gameController.isGameOver) inputHandler.onPanStart(info);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!gameController.isGameOver) inputHandler.onPanUpdate(info);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (!gameController.isGameOver) inputHandler.onPanEnd(info);
  }
}
