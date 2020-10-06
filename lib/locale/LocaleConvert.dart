import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// 다국어 지원 (en, ko)
class LocaleConvert {
  final Locale locale;

  LocaleConvert(this.locale);

  /// 필요한 경우 JSON 으로 변경
  /// 초기엔 간단한 구성으로 Map 으로 구현
  static Map _local = {
    'en': {'home': 'Home', 'setting': 'Setting', 'about': 'About', 'connectedAirPods': 'Connected AirPods'},
    'ko': {'home': '홈', 'setting': '설정', 'about': '안내', 'connectedAirPods': '에어팟 연결'}
  };

  String l(String key) {
    try {
      return _local[locale.languageCode][key];
    } catch (ex) {
      debugPrint(ex);
      return '';
    }
  }
}

class LocaleConvertDelegate extends LocalizationsDelegate<LocaleConvert> {
  @override
  bool isSupported(Locale locale) => ['en', 'ko'].contains(locale.languageCode);

  @override
  Future<LocaleConvert> load(Locale locale) {
    return SynchronousFuture<LocaleConvert>(LocaleConvert(locale));
  }

  @override
  bool shouldReload(LocaleConvertDelegate old) => false;
}
