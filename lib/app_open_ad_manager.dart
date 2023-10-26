import 'package:google_mobile_ads/google_mobile_ads.dart';

bool canShowOpenAd = true;

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  static bool isLoaded = false;
  DateTime? _appOpenLoadTime;
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Load an AppOpenAd.
  void loadAd() {
    AppOpenAd.load(
      adUnitId: "ca-app-pub-3940256099942544/3419835294",
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print("Ad Loadede.................................");
          _appOpenAd = ad;
          isLoaded = true;

          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;

          // here is where I show the Ad as soon as it's loaded
          showAdIfAvailable();
        },
        onAdFailedToLoad: (error) {
          // Handle the error.
        },
      ),
    );
  }

  // Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (!canShowOpenAd) return;
    print(
        "Called=====================================================================");
    if (!isAdAvailable) {
      loadAd();
      return;
    }
    if (_appOpenAd == null) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      canShowOpenAd = false;
      print('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    canShowOpenAd = false;
    _appOpenAd!.show();
  }
}
