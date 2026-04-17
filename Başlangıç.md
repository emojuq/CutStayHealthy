# Proje Adı: Junk Slash (2D Mobil/Web Oyunu)

## 1. Oyun Özeti ve Görsel Tarz
* **Tür:** 2D Arcade / Slicing (Fruit Ninja benzeri).
* **Tema:** Sağlıklı yaşama teşvik. Ekrana fırlatılan "Sağlıksız (Abur Cubur)" yiyecekler kesilmeli, "Sağlıklı" yiyeceklere dokunulmamalıdır.
* **Görsel Tarz:** Modern, canlı renkli, kalın çizgili vektörel 2D grafikler. Minimalist ve karanlık temalı UI.

## 2. Teknoloji Yığını (Tech Stack)
* **Frontend / Oyun Motoru:** Flutter ve Dart. 2D fizik ve render işlemleri için `Flame` oyun motoru paketi kullanılmalıdır.
* **Veri/Mantık Yönetimi:** Gerektiğinde Python scriptleri ile bölüm zorluk konfigürasyonları (JSON/YAML formatında) oluşturulup Flutter'a entegre edilebilir.

## 3. Temel Mekanikler
### A. Spawner (Fırlatıcı) ve Fizik (Flame Engine)
* Ekranın altından rastgele noktalardan (X ekseni) Flame `PositionComponent` nesneleri fırlatılır.
* Objelere yukarı yönlü ve hafifçe sağa/sola rastgele bir `Vector2` kuvveti uygulanır.
* Flame'in dâhili fizik veya yerçekimi simülasyonu kullanılarak objelerin parabolik bir kavis çizerek aşağı düşmesi sağlanır.
* Performans için oluşturulan nesneler geri dönüştürülmeli (Object Pooling).

### B. Kesme (Slicing) ve Kontroller
* `PanDetector` veya `Draggable` kullanılarak oyuncunun ekrandaki parmak kaydırma hareketleri (Trail) yakalanır.
* Parmak izi, ekrandaki nesnelerin `Hitbox` bileşenleriyle kesiştiğinde (Collision Detection) kesilme olayı tetiklenir.

### C. Parçalanma Efekti
* Nesne kesildiğinde orijinal Sprite yok edilir; yerine sol ve sağ yarımı temsil eden iki yeni Sprite çıkar.
* Parçalara zıt yönlerde fiziksel bir itme uygulanır. Particle API kullanılarak kesilme efektleri (susam, su damlası vb.) eklenir.

## 4. Oyun Objeleri (Entities)
### Hedefler (Sağlıksız Yiyecekler - KESİLECEK)
* **Tipler:** Hamburger, Asitli İçecek Kutusu, Patates Kızartması.
* **Kurallar:** Kesilirse +10 Puan. Kesilmeden ekranın altına düşerse -1 Can.

### Bombalar (Sağlıklı Yiyecekler - KESİLMEYECEK)
* **Tipler:** Brokoli, Avokado, Su Şişesi.
* **Kurallar:** Kesilirse Game Over. Kesilmeden aşağı düşerse pasif başarı.

## 5. AI (Gemini) İçin Geliştirme Adımları İsteri
Lütfen bu projeyi Flutter/Flame altyapısıyla aşağıdaki gibi modüllere ayırarak inşa et:
1.  **game_controller.dart:** Skor, can, zorluk eğrisi ve state yönetimi.
2.  **spawner_component.dart:** Rastgele obje fırlatma sistemi ve havuz (pool) yönetimi.
3.  **sliceable_item.dart:** Yiyeceklerin fiziksel özellikleri, sprite tanımları ve parçalanma mantığı.
4.  **input_handler.dart:** Parmak izi (trail) oluşturma ve hit_box çarpışma algılamaları.