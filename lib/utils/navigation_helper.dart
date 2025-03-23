import 'package:flutter/material.dart';

class NavigationHelper {
  static void pushReplacement(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
