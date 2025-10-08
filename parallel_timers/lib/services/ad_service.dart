import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final adServiceProvider = Provider((ref) => AdService());

class AdService {
  BannerAd? _bannerAd;
  final String _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test ID

  void loadBannerAd({required Function(BannerAd) onAdLoaded}) {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          onAdLoaded(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void dispose() {
    _bannerAd?.dispose();
  }
}