class ComboSystem {
  int _currentCombo = 0;
  double _lastSliceTime = 0.0;
  static const double comboThresholdSeconds = 0.5;

  void registerSlice(double currentTime) {
    if (currentTime - _lastSliceTime <= comboThresholdSeconds) {
      _currentCombo++;
    } else {
      _currentCombo = 1;
    }
    _lastSliceTime = currentTime;
  }

  void reset() {
    _currentCombo = 0;
    _lastSliceTime = 0.0;
  }

  int get multiplier {
    if (_currentCombo >= 4) return 3;
    if (_currentCombo >= 3) return 2;
    return 1;
  }

  bool get isComboActive => _currentCombo >= 3;
  int get currentComboCount => _currentCombo;
}
