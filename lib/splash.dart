import 'dart:async';

import 'package:flutter/material.dart';
import 'package:krishi_connect_app/main_screen.dart';
import 'package:krishi_connect_app/pages/registeration.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      bool isRegistered = SharedPrefHelper.isRegistered();
      if (isRegistered) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Registeration()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          const Image(
            image: AssetImage('assets/images/farm1.jpg'),
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: height * 0.6,
            left: width * 0.05,
            child: const Text(
              'Krishi-Connect',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: height * 0.7,
            width: width * 0.75,
            left: width * 0.16,
            child: const Text(
              'Bridging the gap between Farmers and Company',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
