import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class ApiService {
  static const String baseUrl = "https://krishi-connect-app.onrender.com";

  // Future<Map<String, dynamic>> registerUser({
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required String password,
  //   required String role,
  //   required String location,
  //   String profilePicture = "",
  // }) async {
  //   final url = Uri.parse("$baseUrl/api/public/register");

  //   final Map<String, dynamic> requestBody = {
  //     "name": name,
  //     "email": email,
  //     "phone": phone,
  //     "passwordHash": password,
  //     "role": role,
  //     "location": location,
  //     "profilePicture": profilePicture,
  //   };

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(requestBody),
  //     );

  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       return jsonDecode(response.body);
  //     } else {
  //       return {"error": "Failed to register: ${response.body}"};
  //     }
  //   } catch (e) {
  //     return {"error": "An error occurred: $e"};
  //   }
  // }

  Future<Map<String, dynamic>> registerUserWithImage({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    required String location,
    File? profilePicFile,
  }) async {
    final url = Uri.parse("$baseUrl/api/public/registerWithImage");
    final request = http.MultipartRequest('POST', url);

    // Prepare user data as JSON string
    final Map<String, dynamic> userData = {
      "name": name,
      "email": email,
      "phone": phone,
      "passwordHash": password,
      "role": role,
      "location": location,
    };

    // Add user JSON string in a field named "user"
    request.fields['user'] = jsonEncode(userData);

    // Add profile picture file if exists
    if (profilePicFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profilePic',
        profilePicFile.path,
        contentType: MediaType('image', 'jpeg'), // or adjust if PNG
        filename: basename(profilePicFile.path),
      ));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {"status": "success", "data": response.body};
      } else {
        return {
          "error":
              "Failed to register. Status: ${response.statusCode}, Response: ${response.body.isEmpty ? 'Empty body' : response.body}"
        };
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

  Future<Map<String, dynamic>> getBuyerRequestById2({
    required String businessId,
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/authenticated/buyer-requests/$businessId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch buyer request");
    }
  }

  Future<Map<String, dynamic>> getUserProfile(
      {required String token, required String userId}) async {
    final url = Uri.parse("$baseUrl/api/public/users/id/$userId");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
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

  Future<Map<String, dynamic>> updateBuyerRequest({
    required int requestId,
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
      "requestId": requestId,
      "businessId": businessId,
      "title": title,
      "description": description,
      "category": category,
      "requiredQuantity": requiredQuantity,
      "unit": unit,
      "maxPrice": maxPrice,
      "location": location,
      "status": "OPEN",
    };

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Update successful: ${response.body}");
        return jsonDecode(response.body);
      } else {
        print("Update failed: ${response.body}");
        return {"error": "Failed to update buyer request: ${response.body}"};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }

  Future<List<Map<String, dynamic>>> getUserByRole(
      {required String token, required String role}) async {
    final url = Uri.parse("$baseUrl/api/public/users/role/$role");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> createFarmerListing({
    required int farmerId,
    required String title,
    required String description,
    required String category,
    required String unit,
    required String location,
    required int requiredQuantity,
    required double maxPrice,
    required File? profilePicFile,
    required String status,
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/api/authenticated/listing");

    print(
        "$farmerId, $title, $description, $category, $unit, $location, $requiredQuantity, $maxPrice, $status, $token , $profilePicFile");

    final request = http.MultipartRequest('POST', url);
    final Map<String, dynamic> listingData = {
      "farmerId": farmerId,
      "title": title,
      "description": description,
      "category": category,
      "unit": unit,
      "location": location,
      "quantity": requiredQuantity,
      "price": maxPrice,
      "status": status,
    };

    request.fields['listing'] = jsonEncode(listingData);

    if (profilePicFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'imageUrl',
        profilePicFile.path,
        contentType: MediaType('image', 'jpeg'),
        filename: basename(profilePicFile.path),
      ));
    }

    request.headers['Authorization'] = 'Bearer $token';

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"status": "success", "data": jsonDecode(response.body)};
      } else {
        return {
          "error":
              "Failed to create listing. Status: ${response.statusCode}, Response: ${response.body.isEmpty ? 'Empty body' : response.body}"
        };
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }

  Future<List<Map<String, dynamic>>> getFarmerListingById({
    required String token,
    required String farmerId,
  }) async {
    final url =
        Uri.parse("$baseUrl/api/authenticated/listing/farmer/$farmerId");

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

  Future<List<Map<String, dynamic>>> getFarmerListing(
      {required String token}) async {
    final url = Uri.parse("$baseUrl/api/authenticated/listing");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print("ERROR: ${response.statusCode}");
        print("BODY: ${response.body}");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> searchFarmerListing(
      {required String token, required String query}) async {
    final url = Uri.parse("$baseUrl/api/authenticated/listing/search/$query");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print("ERROR: ${response.statusCode}");
        print("BODY: ${response.body}");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> searchBuyerListing(
      {required String token, required String query}) async {
    final url =
        Uri.parse("$baseUrl/api/authenticated/buyer-requests/search/$query");

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print("ERROR: ${response.statusCode}");
        print("BODY: ${response.body}");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> startConversation({
    required int senderId,
    required int receiverId,
    int? listingId,
    int? buyerRequestId,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/api/chat/conversations');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Build body with required fields
    final Map<String, dynamic> body = {
      "senderId": senderId,
      "receiverId": receiverId,
    };

    // Add optional fields only if they're not null
    if (listingId != null) {
      body["listingId"] = listingId;
    }
    if (buyerRequestId != null) {
      body["buyerRequestId"] = buyerRequestId;
    }

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Conversation started: ${response.body}");
    } else {
      print("Failed to start conversation: ${response.statusCode}");
      print(response.body);
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserConversations({
    required int userId,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/api/chat/users/conversations/$userId');

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      // Safely cast each item to Map<String, dynamic>
      final List<Map<String, dynamic>> conversations =
          jsonList.whereType<Map<String, dynamic>>().toList();

      return conversations;
    } else {
      print("Failed to load conversations: ${response.statusCode}");
      print(response.body);
      return [];
    }
  }

 Future<List<Map<String, dynamic>>> fetchChatMessages({
  required int conversationId,
  required String token,
}) async {
  print("Fetching messages for conversation ID: $conversationId");
  final url =
      Uri.parse("$baseUrl/api/chat/conversations/$conversationId/messages");

  try {
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map<Map<String, dynamic>>((msg) => Map<String, dynamic>.from(msg)).toList();
    } else {
      print("❌ Failed to fetch messages: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("❌ Exception while fetching messages: $e");
    return [];
  }
}
}
