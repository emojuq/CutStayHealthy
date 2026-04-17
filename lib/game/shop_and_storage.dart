import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopAndStorage {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static int get gold => prefs.getInt('gold') ?? 0;
  static Future<void> addGold(int amount) async {
    await prefs.setInt('gold', gold + amount);
  }
  static Future<void> spendGold(int amount) async {
    if (gold >= amount) {
      await prefs.setInt('gold', gold - amount);
    }
  }

  static String get equippedTrail => prefs.getString('equippedTrail') ?? 'Beyaz';
  static Future<void> equipTrail(String trailName) async {
    await prefs.setString('equippedTrail', trailName);
  }

  static String get langCode => prefs.getString('langCode') ?? 'tr';
  static Future<void> setLangCode(String code) async {
    await prefs.setString('langCode', code);
  }

  static bool get musicOn => prefs.getBool('musicOn') ?? true;
  static Future<void> setMusicOn(bool value) async {
    await prefs.setBool('musicOn', value);
  }

  static bool get sfxOn => prefs.getBool('sfxOn') ?? true;
  static Future<void> setSfxOn(bool value) async {
    await prefs.setBool('sfxOn', value);
  }

  static String get equippedBackground {
    String eBg = prefs.getString('equippedBackground') ?? 'Klasik Ahşap';
    if (eBg == 'Karanlık Kesme Tahtası' || eBg == 'Üsküdar Sahili Manzarası' || eBg == 'MMA Kafesi Zemini') {
      prefs.setString('equippedBackground', 'Klasik Ahşap');
      return 'Klasik Ahşap';
    }
    return eBg;
  }
  static Future<void> equipBackground(String bgName) async {
    await prefs.setString('equippedBackground', bgName);
  }

  static bool isUnlocked(String itemId) {
    if (itemId == 'Beyaz' || itemId == 'Karanlık Kesme Tahtası') return true;
    return prefs.getBool('unlocked_$itemId') ?? false;
  }
  static Future<void> unlockItem(String itemId) async {
    await prefs.setBool('unlocked_$itemId', true);
  }

  static DecorationImage get currentBackgroundImage {
    String name = equippedBackground;
    if (name == 'Neon Mutfak') {
      return const DecorationImage(image: AssetImage('assets/images/neon_kitchen.png'), fit: BoxFit.cover);
    } else if (name == 'Retro Fayans') {
      return const DecorationImage(image: AssetImage('assets/images/retro_tiles.png'), fit: BoxFit.cover);
    } else if (name == 'Zıtlık Arenası') {
      return const DecorationImage(image: AssetImage('assets/images/arena_clash.png'), fit: BoxFit.cover);
    }
    return const DecorationImage(image: AssetImage('assets/images/premium_wood_board.png'), fit: BoxFit.cover);
  }
}
