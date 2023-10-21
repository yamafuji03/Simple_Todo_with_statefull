import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// バナー広告をインスタンス化
BannerAd myBanner = BannerAd(
  adUnitId: getTestAdBannerUnitId(),
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);

// プラットフォーム（iOS / Android）に合わせてデモ用広告IDを返す
String getTestAdBannerUnitId() {
  String testBannerUnitId = "";
  if (Platform.isAndroid) {
    // Android のとき
    testBannerUnitId =
        "ca-app-pub-3940256099942544/6300978111"; // Androidのデモ用バナー広告ID
  } else if (Platform.isIOS) {
    // iOSのとき
    testBannerUnitId =
        "ca-app-pub-3940256099942544/2934735716"; // iOSのデモ用バナー広告ID
  }
  return testBannerUnitId;
}
