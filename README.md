# Sağlıklı Kal (Junk Slash) 🍏🥷

**Sağlıklı Kal**, Flutter ve Flame motoru kullanılarak geliştirilmiş, oyuncuların sağlıklı yiyecekleri hedeflerken zararlı abur cuburlardan kaçınmasını amaçlayan 2D Arcade bir mobil oyundur. Bu projede oyuncu refleksleri test edilirken aynı zamanda oyun içerisinde sağlıklı bir beslenme deneyimi teşvik edilir.

## 🎮 Özellikler

*   **3 Farklı Oyun Modu:**
    *   **Klasik Mod:** 3 Can hakkıyla sağlıklı yiyecekleri maksimum oranda kestiğiniz hayatta kalma odaklı mod. Zararlıları keserseniz can gider!
    *   **Zamana Karşı Kıyasıya:** Sınırlı süre içerisinde en yüksek skoru toplamayı hedeflediğiniz hızlı tempolu oynanış.
    *   **Antrenman / Sparring Modu:** Oyuncunun yeteneklerini baskı altında kalmadan test ettiği ve can sınırının farklılaştığı serbest eğitim modu.
*   **Aksiyon Mekanikleri:** Kesme (Slice) mekaniği, bomba yiyecekler, hareket eden objeler (spawner algoritmaları) ve kombo sistemi.
*   **Joker ve Güçlendirmeler:** Oyun içi para ve deneyimle etkinleştirilebilen geçici yavaşlatma *(Slow-mo)* veya coşku *(Frenzy)* gibi destekler.
*   **Alışveriş Sistemi:** Toplanan oyun içi altınlar/puanlar ile arkaplanlar veya oyun elementlerine eklentiler açılabilir.
*   **Reklam Entegrasyonu:** AdMob altyapısı mevcuttur. Banner, Geçiş Reklamı (Interstitial) ve tek seferlik Canlanma Özelliği (Rewarded Ads) ile oyun içi gelir senaryoları desteklenir.
*   **Performans & Görsellik:** Flutter 60 FPS kapasitesini ve `google_fonts` ile çekici UI tipografilerini barındırır.


## 🛠️ Kullanılan Teknolojiler & Paketler
Projedeki ana bağımlılıklar ve modern kütüphaneler aşağıdaki gibidir:
*   [Flutter SDK](https://flutter.dev/)
*   [Flame Mimarisi (`flame`)](https://docs.flame-engine.org/) - 2D Oyun motoru altyapısı.
*   `flame_audio` - Müzik, efekt ve ses yöneticisi.
*   `shared_preferences` - Market durumu, güncel arka plan, altın ve kullanıcı ayarlarının yerel bellekte tutulması.
*   `google_mobile_ads` - Gelir modeli yönetimi.
*   `flutter_launcher_icons` - Otomatik uygulama logoları.
*   `google_fonts` - Zengin tipografi ve metin stilleri.

## 🚀 Kurulum ve Başlatma

Bu projeyi bilgisayarınızda çalıştırmak veya derlemek isterseniz aşağıdaki adımları takip edin.

1. **Gereksinimler:**
    - Flutter SDK son versiyon.
    - Android Studio VEYA VS Code.
    - Bir Android Emulatör veya fiziksel bir test cihazı.

2. **Projeyi Çekme ve Paketleri Yükleme:**
   Projeyi klonladıktan veya açtıktan sonra bağımlılıkların indirilmesi için:
   ```bash
   flutter pub get
   ```

3. **Cihazda Çalıştırmak:**
   Gerekli Emülatörü seçip hata ayıklama modunda görmek için:
   ```bash
   flutter run
   ```

4. **Kendi AdMob Kodlarınızı Girin:**
   `lib/utils/ad_helper.dart` içindeki kimlikleri (Ad Unit IDs) veya `android/app/src/main/AndroidManifest.xml` dosyasındaki App-ID değerlerini canlıya (Release) çıkmadan önce kendi ID'lerinizle güncellediğinizden emin olun.

5. **Google Play İçin Proje Çıktısı Alma:**
   ```bash
   flutter build appbundle --release
   ```
   Çıktı, `build\app\outputs\bundle\release\app-release.aab` klasörüne iletilecektir.

## 🤝 Katkıda Bulunma ve Geliştirme

Bu proje "Mümkün olan en akıcı ve dinamik 2D mobil oyun deneyimi" oluşturma hedefiyle modüler altyapıda kodlanmıştır. Eğer oyuna farklı silahlar, kılıç izleri (slice particles) veya yeni yiyecekler eklemek isterseniz `lib/game/` altındaki `spawner_component.dart` veya `sliceable_item.dart` dosyalarını inceleyebilirsiniz. Olay yöneticisinin ana kalbi `game_controller.dart` içindedir.

---
*İyi Oyunlar, Sağlıkla Kalın!* 🍎✨
