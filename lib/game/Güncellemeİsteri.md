# GÜNCELLEME İSTERİ: Junk Slash (V1.2 - Mobil Ekran Uyumluluğu ve Responsive UI)

## 1. Temel Sorun Analizi
Oyun mobil cihazda çalışıyor ancak tüm grafiksel varlıklar (Sprite'lar), butonlar, metinler ve spawner koordinatları ekran boyutuna göre çok büyük ve kaba duruyor, ekrandan taşıyor. Oyunun dikey (Portrait) ve yatay (Landscape) modda, her ekran boyutunda kusursuz, orantılı ve estetik görünmesi gerekiyor.

## 2. Teknik Çözüm İsterleri (Flutter + Flame)

Lütfen mevcut koda şu responsive design prensiplerini entegre et:

### A. Flame Game Viewport (Sanal Çözünürlük)
Mevcut `FlameGame` sınıfına (örn: `JunkSlashGame`) bir **"Sanal Çözünürlük" (Virtual Resolution)** tanımlanmalıdır.
* **İster:** Oyunun fiziksel dünyası, ekranın gerçek pikselleri yerine sabit bir sanal tuval boyutu (örn: 1080x1920 dikey için) üzerinden hesaplanmalıdır. Flame motoru bu tuvali gerçek ekran boyutuna göre otomatik olarak ölçeklemelidir.
* **Teknik Yöntem:** `FixedResolutionViewport` veya `ResolutionPolicy` kullanılarak oyunun aspect ratio'su (en-boy oranı) korunmalıdır. Siyah barlar (letterboxing) gerekirse eklenmeli ama içerik asla taşmamalıdır.

### B. Obje ve Sprite Ölçeklendirme (Relative Scaling)
Havaya fırlatılan tüm yiyecekler (hamburger, brokoli vb.) ve parçalanma efektleri, ekranın genişliğine göre oransal olarak boyutlandırılmalıdır.
* **İster:** Bir hamburgerin genişliği, ekranın (sanal tuvalin) genişliğinin örneğin %10'undan fazla olmamalıdır.
* **Teknik Yöntem:** `SpriteComponent`'lerin `size` özelliği, sanal çözünürlüğün yüzdeleri kullanılarak dinamik olarak ayarlanmalıdır.

### C. UI Elements (Butonlar, Skor, Can Barı) - Flutter Tarafı
Oyun içi HUD (Heads-Up Display) ve menü ekranları (Ana Menü, Game Over) Flutter widget'ları kullanılarak yapıldıysa (ki muhtemelen öyle), bunlar responsive hale getirilmelidir.
* **İster:** Butonlar, textler ve ikonlar mobil cihaz için kaba durmayacak, zarif ve parmakla dokunmaya uygun boyutlarda olmalıdır.
* **Teknik Yöntem:** `MediaQuery` kullanılarak `size.width` ve `size.height` yüzdeleriyle `Container`, `SizedBox` ve `Text` font boyutları dinamik olarak hesaplanmalıdır. `FittedBox` veya `AspectRatio` widget'ları ile taşmalar engellenmelidir.

### D. Yatay ve Dikey Mod Desteği (Orientation Change)
Oyuncu telefonu döndürdüğünde oyun dünyası ve UI anında uyum sağlamalıdır.
* **İster:** Yatay modda (Landscape) yiyecekler daha geniş bir alanda fırlatılmalı, UI elemanları (skor, can) ekranın köşelerine orantılı yerleşmelidir.
* **Teknik Yöntem:** `FlameGame` içindeki `onGameResize` metodu override edilerek sanal tuvalin ve spawner koordinatlarının yeni boyutlara göre güncellenmesi sağlanmalıdır.

## 3. Beklenen Çıktı Modülleri
Lütfen şu kod bloklarını responsive yapıya uygun şekilde güncelle veya yeniden oluştur:
1.  **main.dart / junk_slash_game.dart:** Viewport ve Sanal Çözünürlük ayarları.
2.  **spawner_component.dart:** Fırlatma koordinatlarının sanal çözünürlüğe göre ayarlanması.
3.  **sliceable_item.dart:** Sprite'ların relative (oransal) ölçeklendirilmesi.
4.  **hud_ui.dart (Flutter Widget):** `MediaQuery` destekli responsive skor ve can barı tasarımı.