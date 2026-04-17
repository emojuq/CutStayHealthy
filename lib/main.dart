import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/main_menu.dart';
import 'game/shop_and_storage.dart';
import 'game/audio_manager.dart';
import 'utils/ad_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await AdHelper().initialize();
  await ShopAndStorage.init();
  await AudioManager.init();
  AudioManager.playBgm('Arcade Upbeat.mp3');
  runApp(
    MaterialApp(
      title: 'Junk Slash',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const MainMenu(),
    ),
  );
}
