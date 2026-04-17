import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_screen.dart';
import 'shop_menu.dart';
import '../game/game_mode_manager.dart';
import '../game/shop_and_storage.dart';
import 'localization.dart';
import 'settings_menu.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/ad_helper.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});
  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _showUI = false;

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
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));
    
    _animController.forward().then((_) {
      if (mounted) {
        setState(() {
          _showUI = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String lang = ShopAndStorage.langCode;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: ShopAndStorage.currentBackgroundImage,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // HEADER (Settings & Gold)
              AnimatedOpacity(
                opacity: _showUI ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: _buildHeader(),
              ),

              // CENTER CONTENT (Title & Buttons)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildTitle(),
                      ),
                    ),
                    
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      height: _showUI ? 120 : 0,
                      margin: EdgeInsets.only(top: _showUI ? 48 : 0),
                      child: AnimatedOpacity(
                        opacity: _showUI ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 600),
                        child: _buildActionButtons(lang),
                      ),
                    ),
                  ],
                ),
              ),
              // BANNER AD
              if (_isBannerAdLoaded)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (!_showUI) return const SizedBox.shrink(); // Ignore touches if invisible
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70, size: 28),
            onPressed: () async {
              await showDialog(context: context, builder: (_) => const SettingsMenu());
              setState(() {});
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Text('💰 ${ShopAndStorage.gold}', style: GoogleFonts.poppins(color: Colors.yellowAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'JUNK SLASH',
            style: GoogleFonts.bungee(
              fontSize: 48,
              color: Colors.white,
              shadows: [
                const Shadow(color: Colors.black, offset: Offset(2, 3), blurRadius: 4),
                const Shadow(color: Colors.redAccent, offset: Offset(0, 0), blurRadius: 15),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Cut the Junk, Keep the Healthy!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white70,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              shadows: [const Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(String lang) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _MainActionButton(
          title: Localization.get(lang, 'classic_mode'), // Fallback wording for "Select Mode" mapped later
          displayTitle: "MOD SEÇ / PLAY", 
          icon: Icons.play_arrow,
          color: const Color(0xFFff4b2b),
          onTap: () => _showModeSelectionDialog(lang),
        ),
        const SizedBox(width: 48),
        _MainActionButton(
          title: Localization.get(lang, 'shop'),
          displayTitle: null,
          icon: Icons.store,
          color: Colors.amber[800]!,
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShopMenu()));
            setState(() {});
          },
        ),
      ],
    );
  }

  void _showModeSelectionDialog(String lang) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a2e).withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blueAccent, width: 2),
              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 5))],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FittedBox(fit: BoxFit.scaleDown, child: Text("Oyun Modu / Game Mode", textAlign: TextAlign.center, style: GoogleFonts.bungee(fontSize: 18, color: Colors.blueAccent))),
                const SizedBox(height: 20),
                _ModeSelectButton(title: Localization.get(lang, 'classic_mode'), mode: GameMode.classic, color: const Color(0xFFff4b2b)),
                const SizedBox(height: 10),
                _ModeSelectButton(title: Localization.get(lang, 'time_attack'), mode: GameMode.timeAttack, color: const Color(0xFF2b58ff)),
                const SizedBox(height: 10),
                _ModeSelectButton(title: Localization.get(lang, 'sparring'), mode: GameMode.sparring, color: const Color(0xFF00b09b)),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Kapat / Close", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14)),
                )
              ],
            ),
            ),
          ),
        );
      }
    );
  }
}

class _MainActionButton extends StatelessWidget {
  final String title;
  final String? displayTitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MainActionButton({required this.title, this.displayTitle, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white, size: 24),
      label: Text(displayTitle ?? title, style: GoogleFonts.bungee(fontSize: 18, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 6,
        shadowColor: color.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(color: Colors.white38, width: 2),
        ),
      ),
      onPressed: onTap,
    );
  }
}

class _ModeSelectButton extends StatelessWidget {
  final String title;
  final GameMode mode;
  final Color color;

  const _ModeSelectButton({required this.title, required this.mode, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.white24, width: 2),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GameScreen(mode: mode)),
        );
      },
      child: Text(title, style: GoogleFonts.bungee(fontSize: 16, color: Colors.white)),
    );
  }
}

