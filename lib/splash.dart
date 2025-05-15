// // import 'dart:async';

// // import 'package:flutter/material.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:krishi_connect_app/main_screen.dart';
// // import 'package:krishi_connect_app/pages/login.dart';
// // import 'package:krishi_connect_app/pages/registeration.dart';
// // import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});

// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.delayed(Duration(seconds: 3), () {
// //       bool isRegistered = SharedPrefHelper.isRegistered();
// //       if (isRegistered) {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => MainScreen()),
// //         );
// //       } else {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => LoginPage()),
// //         );
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double width = MediaQuery.of(context).size.width;
// //     double height = MediaQuery.of(context).size.height;
// //     return Scaffold(
// //       body: Center(
// //         child: Image.asset(
// //           'assets/images/splash_img.jpg',
// //           width: width * 0.3,
// //         ),
// //       ),
// //       // body: Stack(
// //       //   children: [
// //       //     const Image(
// //       //       image: AssetImage('assets/images/farm1.jpg'),
// //       //       height: double.infinity,
// //       //       fit: BoxFit.cover,
// //       //     ),
// //       //     Positioned(
// //       //       top: height * 0.6,
// //       //       left: width * 0.05,
// //       //       child: const Text(
// //       //         'Krishi-Connect',
// //       //         style: TextStyle(
// //       //           fontSize: 50,
// //       //           fontWeight: FontWeight.bold,
// //       //           color: Colors.white,
// //       //         ),
// //       //       ),
// //       //     ),
// //       //     Positioned(
// //       //       top: height * 0.7,
// //       //       width: width * 0.75,
// //       //       left: width * 0.16,
// //       //       child: const Text(
// //       //         'Bridging the gap between Farmers and Company',
// //       //         style: TextStyle(
// //       //           fontSize: 20,
// //       //           fontWeight: FontWeight.bold,
// //       //           color: Colors.white,
// //       //         ),
// //       //         textAlign: TextAlign.center,
// //       //         maxLines: 2,
// //       //       ),
// //       //     ),
// //       //   ],
// //       // ),
// //     );
// //   }
// // }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:krishi_connect_app/main_screen.dart';
import 'package:krishi_connect_app/pages/login.dart';
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
    _wakeUpBackend().then((_) {
      Future.delayed(Duration(seconds: 2), () {
        bool isRegistered = SharedPrefHelper.isRegistered();
        if (isRegistered) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      });
    });
  }

  Future<void> _wakeUpBackend() async {
    const String backendUrl = "https://krishi-connect-app.onrender.com/";
    try {
      final response = await http.get(Uri.parse(backendUrl));
      print("Backend wake-up response: ${response.statusCode}");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Backend wake-up successful!"),
      //   ),
      // );
    } catch (e) {
      print("Error waking up backend: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error waking up backend. Please try again later."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash_img.jpg',
          width: width * 0.3,
        ),
      ),
    );
  }
}
