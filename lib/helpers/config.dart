import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  static final _config = FirebaseRemoteConfig.instance;

  static const _defaultValues = {
    "interstitial_ad": "ca-app-pub-7014762866941365/7852803777",
    "native_ad": "ca-app-pub-7014762866941365/3366522605",
    "rewarded_ad": "ca-app-pub-7014762866941365/8974313753",
    "show_ads": true
  };

  static Future<void> initConfig() async {
    await _config.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 30)));

    await _config.setDefaults(_defaultValues);
    await _config.fetchAndActivate();
    log('Remote Config Data: ${_config.getBool('show_ads')}');

    _config.onConfigUpdated.listen((event) async {
      await _config.activate();
      log('Updated: ${_config.getBool('show_ads')}');
    });
  }

  static bool get _showAd => _config.getBool('show_ads');

  //ad ids
  static String get nativeAd => _config.getString('native_ad');
  static String get interstitialAd => _config.getString('interstitial_ad');
  static String get rewardedAd => _config.getString('rewarded_ad');

  static bool get hideAds => !_showAd;
}
