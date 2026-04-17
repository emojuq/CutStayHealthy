# GÜNCELLEME İSTERİ: Junk Slash (V1.1 - Oyun Modları ve Ekstra Mekanikler)

## 1. Yeni Oyun Modları (Game Modes)
Mevcut `GameManager` yapısını genişleterek oyuncuya başlangıçta seçebileceği 3 farklı mod sunulmalıdır:
* **Klasik Mod:** Mevcut sistem. 3 Can (Kalp) var. Sağlıksız yiyecek (hedef) kaçarsa 1 can gider. Bomba (sağlıklı yiyecek) kesilirse anında Game Over.
* **Zamana Karşı (Hız Modu):** Can sistemi yoktur. Bombaları kesmek eksi puan (-20) verir ama oyunu bitirmez. Toplam süre 60 saniyedir. Süre azaldıkça `Spawner` fırlatma hızı ve objelerin yerçekimi ivmesi (velocity) spor bir arabanın hızlanması gibi logaritmik olarak artmalıdır.
* **Sparring Modu (Dayanıklılık):** Ekranda sürekli eriyen bir "Kondisyon (Stamina)" barı bulunur. Oyuncu sağlıklı/sağlıksız hedefleri doğru yönettikçe (hedefi kesip, bombayı es geçtikçe) bar biraz dolar. Hata yapıldığında veya ekranda işlem yapılmadan süre geçtiğinde bar hızla erir. Bar sıfırlanınca oyun biter.

## 2. Power-Ups (Güçlendiriciler) ve Kombo Sistemi
Bu mekanikler tüm oyun modlarında rastgele (düşük ihtimalle) fırlatılmalıdır:
* **Detoks Suyu (Slow-Motion):** Mavi parlayan şişe. Kesildiği an `Flame` motorunun `timeScale` değeri 0.3'e çekilerek oyun 5 saniyeliğine ağır çekime girer. Bu sürede spawner sadece "Sağlıksız Yiyecek" atar.
* **Yulaf Kasesi (Frenzy):** Kesildiği an ekrandaki bombalar temizlenir. 4 saniye boyunca ekranın 4 farklı köşesinden inanılmaz bir hızla sadece hedefler (Hamburger, Patates vb.) fırlar.
* **Kombo Sistemi:** `InputHandler` içinde parmak ekrandan hiç kalkmadan (tek bir Trail ile) aynı anda (0.5 saniye aralığında) 3 veya daha fazla hedef kesilirse, kazanılan puan katlanarak artar (örn. 3 hedef = x2, 4 hedef = x3). Ekranda "Kusursuz!" gibi hareketli (floating) bir text efekti çıkmalıdır.

## 3. Metagame ve Kozmetik Dükkanı (Shop)
Oyuncuyu oyunda tutmak için basit bir altın/para ekonomisi eklenmelidir. Oyun sonunda kazanılan puanın %10'u "Altın" olarak hesaba eklenir. `SharedPreferences` veya benzeri bir lokal DB ile kaydedilmelidir.
* **Açılabilir Parmak İzleri (Trails):** Varsayılan beyaz iz. Marketten şunlar alınabilir: Neon Yeşil, Ateş Rengi, Sarı-Kırmızı Çift Renkli İz.
* **Açılabilir Arka Planlar:** Karanlık Kesme Tahtası (Varsayılan), Üsküdar Sahili Manzarası, MMA Kafesi Zemini.

## 4. AI İçin Geliştirme Adımları
Lütfen mevcut Flutter/Flame projesine şu değişiklikleri uygula:
1.  **game_mode_manager.dart:** Klasik, Zaman, Sparring modlarının kurallarını (state) yöneten yeni bir sınıf oluştur.
2.  **powerup_component.dart:** Detoks suyu (slow-mo) ve Yulaf kasesi (frenzy) objelerinin davranışlarını ve sürelerini yaz.
3.  **combo_system.dart:** Tek bir swipe hareketiyle kesilen obje sayısını sayan ve çarpan uygulayan mantığı kur.
4.  **shop_and_storage.dart:** Oyuncunun altınlarını kaydedip, marketten aldığı iz (trail) ve arka plan renklerini Flame oyununa entegre eden yapıyı kur.