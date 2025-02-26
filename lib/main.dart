import 'package:flutter/material.dart';
import 'package:krishi_connect_app/splash.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Krishi-Connect App',
      home: SplashScreen(),
    );
  }
}
