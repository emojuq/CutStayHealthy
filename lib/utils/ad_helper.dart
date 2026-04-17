import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static final AdHelper _instance = AdHelper._internal();
  factory AdHelper() => _instance;
  AdHelper._internal();

  bool _isAdMobInitialized = false;

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // Cihazınızda test etmek isterseniz Test ID'lerini kopyalayabilirsiniz, canlı sürüm için sizin ID'leriniz kullanıldı.
  static String get bannerAdUnitId {
    if (kReleaseMode) {
      if (Platform.isAndroid) return 'ca-app-pub-1754889019315119/7685595119';
      // if (Platform.isIOS) return 'ios-banner-id';
    }
    // Test Banner ID
    return 'ca-app-pub-3940256099942544/6300978111';
  }

  static String get interstitialAdUnitId {
    if (kReleaseMode) {
      if (Platform.isAndroid) return 'ca-app-pub-1754889019315119/6012374616';
    }
    // Test Interstitial ID
    return 'ca-app-pub-3940256099942544/1033173712';
  }

  static String get rewardedAdUnitId {
    if (kReleaseMode) {
      if (Platform.isAndroid) return 'ca-app-pub-1754889019315119/6372513444';
    }
    // Test Rewarded ID
    return 'ca-app-pub-3940256099942544/5224354917';
  }

  Future<void> initialize() async {
    if (_isAdMobInitialized) return;
    await MobileAds.instance.initialize();
    _isAdMobInitialized = true;
    
    // Uygulama açılışında reklamları önceden yükle
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdClosed}) {
    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial before loaded.');
      if (onAdClosed != null) onAdClosed();
      _loadInterstitialAd(); // Load for next time
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd(); // Preload next
        if (onAdClosed != null) onAdClosed();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
        if (onAdClosed != null) onAdClosed();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null; // Set to null after starting display process to prevent reuse
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load a rewarded ad: ${err.message}');
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedAd({required VoidCallback onRewardEarned, VoidCallback? onAdClosed}) {
    if (_rewardedAd == null) {
      debugPrint('Warning: attempt to show rewarded before loaded.');
      if (onAdClosed != null) onAdClosed();
      _loadRewardedAd(); // Load for next time
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd(); // Preload next
        if (onAdClosed != null) onAdClosed();
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd();
        if (onAdClosed != null) onAdClosed();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      onRewardEarned();
    });
    _rewardedAd = null; // Set to null immediately
  }
}
