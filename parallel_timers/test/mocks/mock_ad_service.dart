import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:parallel_timers/services/ad_service.dart';

class MockAdService implements AdService {
  @override
  void loadBannerAd({required Function(BannerAd) onAdLoaded}) {
    // Do nothing in the mock
  }

  @override
  void dispose() {
    // Do nothing in the mock
  }
}