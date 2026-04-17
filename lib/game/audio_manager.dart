import 'package:flame_audio/flame_audio.dart';
import 'shop_and_storage.dart';

class AudioManager {
  static bool get bgmEnabled => ShopAndStorage.musicOn;
  static bool get sfxEnabled => ShopAndStorage.sfxOn;

  static Future<void> init() async {
    // Bu kısım sistemin çökmesini engeller ve kullanıcının mp3'leri koyabilmesi için stub oluşturur.
    FlameAudio.bgm.initialize();
  }
  static final Map<String, DateTime> _lastPlayTimes = {};

  static void playSfx(String file, {int cooldownMs = 100}) {
    if (!sfxEnabled) return;

    final now = DateTime.now();
    if (_lastPlayTimes.containsKey(file)) {
      if (now.difference(_lastPlayTimes[file]!).inMilliseconds < cooldownMs) {
        return; // Aynı ses efekti kısa süre içinde tekrar çalınamaz (ses kirliliğini önler)
      }
    }
    _lastPlayTimes[file] = now;

    try {
      FlameAudio.play(file);
    } catch (e) {
      print('[AUDIO MANAGER] HATA: $file bulunamadı. Lütfen "assets/audio/$file" konumuna ekleyin.');
    }
  }

  static void playBgm(String file) {
    if (!bgmEnabled) return;
    try {
      if (FlameAudio.bgm.isPlaying) return;
      FlameAudio.bgm.play(file);
    } catch (e) {
      print('[AUDIO MANAGER] HATA: $file bulunamadı. Lütfen "assets/audio/$file" konumuna ekleyin.');
    }
  }
  
  static void stopBgm() {
    try {
      FlameAudio.bgm.stop();
    } catch(e) {}
  }
}
