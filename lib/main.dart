import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pod_stat/layout/RootTab.dart';
import 'package:pod_stat/locale/LocaleConvert.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(localizationsDelegates: [
      LocaleConvertDelegate(),
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ], supportedLocales: [
      Locale('en', 'US'),
      Locale('ko', '')
    ], home: RootTab());
  }
}
