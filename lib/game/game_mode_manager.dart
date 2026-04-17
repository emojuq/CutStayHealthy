enum GameMode { classic, timeAttack, sparring }

class GameModeManager {
  final GameMode _currentMode;
  
  GameModeManager(this._currentMode);

  GameMode get mode => _currentMode;
  bool get hasLives => _currentMode == GameMode.classic;
  bool get hasTimer => _currentMode == GameMode.timeAttack;
  bool get hasStamina => _currentMode == GameMode.sparring;
}
