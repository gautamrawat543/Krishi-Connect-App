import 'package:flutter/material.dart';
import 'package:krishi_connect_app/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  runApp(MyApp());
}

final GlobalKey<_MyAppState> myAppKey = GlobalKey<_MyAppState>();

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: myAppKey);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    String? langCode = SharedPrefHelper.getLanguageCode();
    setState(() {
      _locale = langCode != null ? Locale(langCode) : const Locale('en');
    });
  }

  void changeLanguage(String code) async {
    await SharedPrefHelper.setLanguageCode(code);
    setState(() {
      _locale = Locale(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Krishi-Connect App',
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SplashScreen(),
    );
  }
}
