import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  static const String baseUrl = "https://krishi-connect-app.onrender.com";

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    required String location,
    String profilePicture = "",
  }) async {
    final url = Uri.parse("$baseUrl/api/public/register");

    final Map<String, dynamic> requestBody = {
      //   "userId": 0, // Let the backend handle ID assignment
      "name": name,
      "email": email,
      "phone": phone,
      "passwordHash": password, // Ideally, hash password before sending
      "role": role,
      "location": location,
      "profilePicture": profilePicture,
      //   "createdAt": DateTime.now().toIso8601String(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Failed to register: ${response.body}"};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }

  Future<Map<String, dynamic>> loginUser(
      {required String phone, required String password}) async {
    final url = Uri.parse("$baseUrl/api/public/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phone,
          "passwordHash": password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = response.body;
        print("Login Successful: ${responseData}");
        return {"token": responseData};
      } else {
        print("Login Failed: ${response.body}");
        return {"error": "Login failed: ${response.body}"};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }

  Future<Map<String, dynamic>> getUserByPhone(
      {required String phone, required String token}) async {
    final url = Uri.parse("$baseUrl/api/public/users/phone/$phone");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "User not found: ${response.body}"};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }
}
