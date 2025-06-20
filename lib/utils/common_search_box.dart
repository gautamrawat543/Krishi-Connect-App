import 'package:flutter/material.dart';
import 'package:krishi_connect_app/utils/app_styles.dart'; 

class CommonSearchBox extends StatelessWidget {
  final String hintText;

  const CommonSearchBox({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryGreenDark, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.search, color: Colors.green),
        ],
      ),
    );
  }
}
