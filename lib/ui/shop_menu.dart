import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/shop_and_storage.dart';
import 'localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_helper.dart';

class ShopMenu extends StatefulWidget {
  const ShopMenu({super.key});

  @override
  State<ShopMenu> createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _buyItem(String name, int price) async {
    if (ShopAndStorage.gold >= price) {
      await ShopAndStorage.spendGold(price);
      await ShopAndStorage.unlockItem(name);
      setState(() {});
    }
  }

  void _equipTrail(String name) async {
    await ShopAndStorage.equipTrail(name);
    setState(() {});
  }

  void _equipBg(String name) async {
    await ShopAndStorage.equipBackground(name);
    setState(() {});
  }

  Widget _buildItem(String type, String name, int price) {
    String lang = ShopAndStorage.langCode;
    bool isUnlocked = ShopAndStorage.isUnlocked(name);
    bool isEquipped = (type == 'trail' ? ShopAndStorage.equippedTrail : ShopAndStorage.equippedBackground) == name;
    
    String displayName = Localization.get(lang, name);

    return ListTile(
      title: Text(displayName, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
      subtitle: isUnlocked ? null : Text('$price ${Localization.get(lang, "gold_earned").replaceAll("+{val} ", "")}', style: const TextStyle(color: Colors.yellowAccent)),
      trailing: isUnlocked
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: isEquipped ? Colors.green : Colors.grey),
              onPressed: () => type == 'trail' ? _equipTrail(name) : _equipBg(name),
              child: Text(isEquipped ? Localization.get(lang, 'equipped') : Localization.get(lang, 'equip'), style: const TextStyle(color: Colors.white)),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () => _buyItem(name, price),
              child: Text(Localization.get(lang, 'buy'), style: const TextStyle(color: Colors.black)),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String lang = ShopAndStorage.langCode;
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.get(lang, 'shop'), style: GoogleFonts.bungee()),
        backgroundColor: Colors.black,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '💰 ${ShopAndStorage.gold}',
                style: GoogleFonts.poppins(color: Colors.yellowAccent, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: ShopAndStorage.currentBackgroundImage,
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
        children: [
          Text(Localization.get(lang, 'trails_title'), style: GoogleFonts.bungee(color: Colors.redAccent, fontSize: 24)),
          _buildItem('trail', 'Beyaz', 0),
          _buildItem('trail', 'Neon Yeşil', 50),
          _buildItem('trail', 'Ateş Rengi', 100),
          const Divider(color: Colors.white24, height: 40),
          Text(Localization.get(lang, 'bg_title'), style: GoogleFonts.bungee(color: Colors.blueAccent, fontSize: 24)),
          _buildItem('bg', 'Klasik Ahşap', 0),
          _buildItem('bg', 'Neon Mutfak', 250),
          _buildItem('bg', 'Retro Fayans', 500),
          _buildItem('bg', 'Zıtlık Arenası', 800),
        ],
      ),
      ),
      bottomNavigationBar: _isBannerAdLoaded
          ? SafeArea(
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            )
          : null,
    );
  }
}
