import 'package:google_mobile_ads/google_mobile_ads.dart';

void loadAd() {
  BannerAd bannerAd = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/2934735716',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  bannerAd.load();
}
