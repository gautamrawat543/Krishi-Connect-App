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

  Future<List<Map<String, dynamic>>> getBuyerRequest(
      {required String token}) async {
    final url = Uri.parse("$baseUrl/api/authenticated/buyer-requests");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFarmer({required String token}) async {
    final url = Uri.parse("$baseUrl/api/public/users/role/FARMER");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> createBuyerRequest({
    required int businessId,
    required String title,
    required String description,
    required String category,
    required String unit,
    required String location,
    required int requiredQuantity,
    required double maxPrice,
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/api/authenticated/buyer-requests");

    final Map<String, dynamic> requestBody = {
      "businessId": businessId,
      "title": title,
      "description": description,
      "category": category,
      "requiredQuantity": requiredQuantity,
      "unit": unit,
      "maxPrice": maxPrice,
      "location": location,
      "status": "OPEN"
    };
    print(requestBody);
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        return {"error": "Failed to create buyer listing: ${response.body}"};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }

  static Future<Map<String, String>?> getLocationFromPincode(
      String pincode) async {
    final Uri url = Uri.parse('$baseUrl/api/pincode/$pincode');

    try {
      final response = await http.get(url);

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['Status'] == 'Success') {
          List<dynamic> postOffices = responseData['PostOffice'];
          if (postOffices.isNotEmpty) {
            return {
              'Name': postOffices[0]['Name'],
              'State': postOffices[0]['State'],
            };
          }
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getBuyerRequestById({
    required String token,
    required String businessId,
  }) async {
    final url = Uri.parse(
        "$baseUrl/api/authenticated/buyer-requests/business/$businessId");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }


   Future<Map<String, dynamic>> getUserProfile({
    required String token,
    required String userId
  }) async {
    final url = Uri.parse("$baseUrl/api/public/users/id/$userId");

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json",
        "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Failed to fetch user profile: ${response.body}"};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }


}
