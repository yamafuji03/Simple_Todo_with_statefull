import 'dart:io';
// packages
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMob extends StatelessWidget {
  const AdMob({super.key});

  @override
  Widget build(BuildContext context) {
// adMob用変数
    BannerAd myBanner = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111' // android用バナーテストID
          : 'ca-app-pub-3940256099942544/2934735716', // ios用のバナーテストID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();

    return Container(
      height: 50.0, //バナー広告のサイズ 320×50
      width: double.infinity,
      child: AdWidget(ad: myBanner),
    );
    ;
  }
}
