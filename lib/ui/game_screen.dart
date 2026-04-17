import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/junk_slash_game.dart';
import '../game/game_mode_manager.dart';
import '../game/shop_and_storage.dart';
import 'main_menu.dart';
import 'localization.dart';
import '../utils/ad_helper.dart';
import '../game/game_controller.dart';

class GameScreen extends StatelessWidget {
  final GameMode mode;
  const GameScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: ShopAndStorage.currentBackgroundImage),
        child: SafeArea(
          child: GameWidget<JunkSlashGame>(
            backgroundBuilder: (context) => const SizedBox.shrink(),
            game: JunkSlashGame(initialMode: mode),
            overlayBuilderMap: {
            'Tutorial': (context, game) {
              Future.delayed(const Duration(seconds: 3), () {
                if (game.overlays.isActive('Tutorial')) {
                  game.overlays.remove('Tutorial');
                  game.gameController.hasStarted = true;
                }
              });

              String lang = ShopAndStorage.langCode;
              String title = Localization.get(lang, 'how_to_play');
              String desc = '';
              if (mode == GameMode.classic) desc = Localization.get(lang, 'classic_desc');
              else if (mode == GameMode.timeAttack) desc = Localization.get(lang, 'time_desc');
              else if (mode == GameMode.sparring) desc = Localization.get(lang, 'sparring_desc');

              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.amber, width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(fit: BoxFit.scaleDown, child: Text(title, style: GoogleFonts.bungee(color: Colors.amber, fontSize: 24))),
                      const SizedBox(height: 12),
                      Text(desc, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
              );
            },
            'Hud': (context, game) {
              return Stack(
                children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // LEFT CORNER (SCORE)
                        ValueListenableBuilder<int>(
                          valueListenable: game.gameController.scoreNotifier,
                          builder: (context, score, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.amber, width: 2),
                                boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 4, offset: Offset(1, 1))],
                              ),
                              child: Text(
                                Localization.get(ShopAndStorage.langCode, 'hud_score', params: {'val': score.toString()}),
                                style: GoogleFonts.bungee(color: Colors.white, fontSize: 18),
                              ),
                            );
                          },
                        ),
                        // RIGHT CORNER (TIME/STAMINA & LIVES)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (game.gameController.modeManager.hasTimer)
                               ValueListenableBuilder<int>(
                                valueListenable: game.gameController.timeNotifier,
                                builder: (context, time, child) {
                                  return Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.cyanAccent, width: 2),
                                    ),
                                    child: Text(
                                      Localization.get(ShopAndStorage.langCode, 'hud_time', params: {'val': time.toString()}),
                                      style: GoogleFonts.bungee(color: Colors.cyanAccent, fontSize: 18),
                                    ),
                                  );
                                },
                              ),
                            if (game.gameController.modeManager.hasStamina)
                               ValueListenableBuilder<double>(
                                valueListenable: game.gameController.staminaNotifier,
                                builder: (context, stamina, child) {
                                  return Container(
                                    width: 100,
                                    height: 24,
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.amberAccent, width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: stamina / 100.0,
                                        backgroundColor: Colors.transparent,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          stamina > 50 ? Colors.greenAccent : (stamina > 20 ? Colors.orangeAccent : Colors.redAccent)
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            if (game.gameController.modeManager.hasLives) 
                              ValueListenableBuilder<int>(
                                valueListenable: game.gameController.livesNotifier,
                                builder: (context, lives, child) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.redAccent, width: 2),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(3, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                          child: Icon(
                                            index < lives ? Icons.favorite : Icons.favorite_border,
                                            color: const Color(0xFFff4b2b),
                                            size: 20,
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                },
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
            Center(
                  child: ValueListenableBuilder<int>(
                    valueListenable: game.gameController.frenzyNotifier,
                    builder: (context, frenzyTime, child) {
                      if (frenzyTime > 0) {
                        return Text(
                          frenzyTime.toString(),
                          style: GoogleFonts.bungee(color: Colors.redAccent, fontSize: 80, shadows: [const Shadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 5))]),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
             );
            },
            'GameOver': (context, game) {
              int earned = game.gameController.score ~/ 10;
              return Center(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 320),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2c3e50), Color(0xFF000000)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.redAccent, blurRadius: 10, spreadRadius: 1),
                    ],
                    border: Border.all(color: Colors.redAccent, width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Localization.get(ShopAndStorage.langCode, 'game_over'), style: GoogleFonts.bungee(color: Colors.redAccent, fontSize: 32)),
                      const SizedBox(height: 12),
                      Text(
                        '${Localization.get(ShopAndStorage.langCode, 'score')} ${game.gameController.score}',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        Localization.get(ShopAndStorage.langCode, 'gold_earned', params: {'val': earned.toString()}),
                        style: GoogleFonts.poppins(color: Colors.yellowAccent, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      if (game.gameController.modeManager.hasLives && !game.gameController.hasUsedRewardedAd)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            AdHelper().showRewardedAd(
                              onRewardEarned: () {
                                game.gameController.revive();
                              },
                              onAdClosed: () {}, // Do nothing if closed early
                            );
                          },
                          icon: const Icon(Icons.ondemand_video, color: Colors.white, size: 24),
                          label: Text("Revive (+3 Lives)", style: GoogleFonts.bungee(color: Colors.white, fontSize: 16)),
                        ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFff4b2b),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () {
                              ShopAndStorage.addGold(earned).then((_) {
                                  if (!context.mounted) return;
                                  void go() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GameScreen(mode: game.gameController.modeManager.mode)));
                                  if (GameController.totalGameOverCount % 3 == 0) {
                                    AdHelper().showInterstitialAd(onAdClosed: go);
                                  } else {
                                    go();
                                  }
                              });
                            },
                            icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                            label: Text(Localization.get(ShopAndStorage.langCode, 'retry'), style: GoogleFonts.bungee(fontSize: 16, color: Colors.white)),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () {
                              ShopAndStorage.addGold(earned).then((_) {
                                if (!context.mounted) return;
                                void go() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainMenu()));
                                if (GameController.totalGameOverCount % 3 == 0) {
                                  AdHelper().showInterstitialAd(onAdClosed: go);
                                } else {
                                  go();
                                }
                              });
                            },
                            icon: const Icon(Icons.home, color: Colors.white, size: 20),
                            label: Text(Localization.get(ShopAndStorage.langCode, 'main_menu'), style: GoogleFonts.bungee(fontSize: 16, color: Colors.white)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
               ),
              );
            }
          },
          initialActiveOverlays: const ['Hud', 'Tutorial'],
        ),
      ),
      ),
    );
  }
}
