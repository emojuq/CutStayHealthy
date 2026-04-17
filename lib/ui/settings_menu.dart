import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/shop_and_storage.dart';
import '../game/audio_manager.dart';
import 'localization.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  final List<Map<String, String>> _languages = [
    {'code': 'tr', 'name': 'Türkçe'},
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'de', 'name': 'Deutsch'},
  ];

  @override
  Widget build(BuildContext context) {
    String currentLang = ShopAndStorage.langCode;
    String langTitle = Localization.get(currentLang, 'settings');

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2c3e50), Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.blueAccent, width: 2),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(langTitle, style: GoogleFonts.bungee(fontSize: 32, color: Colors.blueAccent)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentLang,
                  dropdownColor: const Color(0xFF2c3e50),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 32),
                  isExpanded: true,
                  style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
                  onChanged: (String? newLang) async {
                    if (newLang != null) {
                      await ShopAndStorage.setLangCode(newLang);
                      setState(() {});
                    }
                  },
                  items: _languages.map((l) {
                    return DropdownMenuItem<String>(
                      value: l['code'],
                      child: Text(l['name']!),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text('Müzik / Music', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
              value: ShopAndStorage.musicOn,
              activeColor: Colors.blueAccent,
              onChanged: (val) async {
                await ShopAndStorage.setMusicOn(val);
                if (!val) {
                  AudioManager.stopBgm();
                } else {
                  AudioManager.playBgm('Arcade Upbeat.mp3');
                }
                setState(() {});
              },
            ),
            SwitchListTile(
              title: Text('Sesler / SFX', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
              value: ShopAndStorage.sfxOn,
              activeColor: Colors.blueAccent,
              onChanged: (val) async {
                await ShopAndStorage.setSfxOn(val);
                setState(() {});
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: GoogleFonts.bungee(fontSize: 24, color: Colors.white),
              ),
            )
          ],
        ),
        ),
      ),
    );
  }
}
