import 'dart:async';

import 'package:flutter/services.dart';

import '../../native_admob_flutter.dart';
import '../events.dart';
import '../utils.dart';

/// An InterstitialAd model to communicate with the model in the platform side.
/// It gives you methods to help in the implementation and event tracking.
///
/// For more info, see:
///   - https://developers.google.com/admob/android/interstitial-fullscreen
///   - https://developers.google.com/admob/ios/interstitial
class InterstitialAd extends LoadShowAd<FullScreenAdEvent> {
  /// The test id for this ad.
  ///   - Android: ca-app-pub-3940256099942544/1033173712
  ///   - iOS: ca-app-pub-3940256099942544/4411468910
  ///
  /// For more info, [read the documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Initialize#always-test-with-test-ads)
  static String get testUnitId => MobileAds.interstitialAdTestUnitId;

  /// The video test id for this ad.
  ///   - Android: ca-app-pub-3940256099942544/8691691433
  ///   - iOS: ca-app-pub-3940256099942544/5135589807
  ///
  /// For more info, [read the documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Initialize#always-test-with-test-ads)
  static String get videoTestUnitId => MobileAds.interstitialAdVideoTestUnitId;

  /// Listen to the events the ad throws
  ///
  /// Usage:
  /// ```dart
  /// ad.onEvent.listen((e) {
  ///   final event = e.keys.first;
  ///   switch (event) {
  ///     case FullScreenAdEvent.loading:
  ///       print('loading');
  ///       break;
  ///     case FullScreenAdEvent.loaded:
  ///       print('loaded');
  ///       break;
  ///     case FullScreenAdEvent.loadFailed:
  ///       final error = e.values.first;
  ///       print('loadFailed ${error.code}');
  ///       break;
  ///     case FullScreenAdEvent.showed:
  ///       print('ad showed');
  ///       break;
  ///     case FullScreenAdEvent.failedToShow;
  ///       final error = e.values.first;
  ///       print('ad failed to show ${error.code}');
  ///       break;
  ///     case FullScreenAdEvent.closed:
  ///       print('ad closed');
  ///       break;
  ///     default:
  ///       break;
  ///   }
  /// });
  /// ```
  ///
  /// For more info, read the [documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-an-interstitial-ad#ad-events)
  Stream<Map<FullScreenAdEvent, dynamic>> get onEvent => super.onEvent;

  bool _loaded = false;

  /// Returns true if the ad was successfully loaded and is ready to be shown.
  bool get isLoaded => _loaded;

  /// Creates a new interstitial ad controller
  InterstitialAd() : super();

  /// Initialize the controller. This can be called only by the controller
  void init() {
    channel.setMethodCallHandler(_handleMessages);
    MobileAds.pluginChannel.invokeMethod('initInterstitialAd', {'id': id});
  }

  /// Dispose the ad to free up resources.
  /// Once disposed, the ad can not be used anymore
  ///
  /// Usage:
  /// ```dart
  /// @override
  /// void dispose() {
  ///   super.dispose();
  ///   interstitialAd?.dispose();
  /// }
  /// ```
  void dispose() {
    super.dispose();
    MobileAds.pluginChannel.invokeMethod('disposeInterstitialAd', {'id': id});
  }

  /// Handle the messages the channel sends
  Future<void> _handleMessages(MethodCall call) async {
    if (isDisposed) return;
    switch (call.method) {
      case 'loading':
        onEventController.add({FullScreenAdEvent.loading: null});
        break;
      case 'onAdFailedToLoad':
        _loaded = false;
        onEventController.add({
          FullScreenAdEvent.loadFailed: AdError.fromJson(call.arguments),
        });
        break;
      case 'onAdLoaded':
        _loaded = true;
        onEventController.add({FullScreenAdEvent.loaded: null});
        break;
      case 'onAdShowedFullScreenContent':
        _loaded = false;
        onEventController.add({FullScreenAdEvent.showed: null});
        _loaded = false;
        break;
      case 'onAdFailedToShowFullScreenContent':
        onEventController.add({
          FullScreenAdEvent.showFailed: AdError.fromJson(call.arguments),
        });
        break;
      case 'onAdDismissedFullScreenContent':
        onEventController.add({FullScreenAdEvent.closed: null});
        break;
      default:
        break;
    }
  }

  /// In order to show an ad, it needs to be loaded first. Use `load()` to load.
  ///
  /// To check if the ad is loaded, call `interstitialAd.isLoaded`. You can't `show()`
  /// an ad if it's not loaded.
  ///
  /// For more info, read the [documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-an-interstitial-ad#load-the-ad)
  ///
  /// If `unitId` is null, `MobileAds.interstitialAdUnitId` or
  /// `MobileAds.interstitialAdTestUnitId` is used
  ///
  /// For more info, read the [documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-an-interstitial-ad#load-the-ad)
  Future<bool> load({
    String unitId,
    bool force = false,
  }) async {
    assert(force != null);
    ensureAdNotDisposed();
    assertMobileAdsIsInitialized();
    if (!debugCheckAdWillReload(isLoaded, force)) return false;
    _loaded = await channel.invokeMethod<bool>('loadAd', {
      'unitId': unitId ??
          MobileAds.interstitialAdUnitId ??
          MobileAds.interstitialAdTestUnitId,
    });
    return _loaded;
  }

  /// Show the interstitial ad. This returns a `Future` that will complete when
  /// the ad gets closed
  ///
  /// The ad must be loaded. To check if the ad is loaded, call
  /// `interstitialAd.isLoaded`. If it's not loaded, throws an `AssertionError`
  ///
  /// For more info, read the [documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-an-interstitial-ad#show-the-ad)
  Future<bool> show() {
    ensureAdNotDisposed();
    assert(isLoaded, '''The ad must be loaded to show. 
      Call interstitialAd.load() to load the ad. 
      Call interstitialAd.isLoaded to check if the ad is loaded before showing.''');
    return channel.invokeMethod<bool>('show');
  }
}
