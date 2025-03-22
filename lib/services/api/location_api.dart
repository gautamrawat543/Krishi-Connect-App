//https://api.postalpincode.in/pincode/401202
// http://www.postalpincode.in/Api-Details

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.postalpincode.in/pincode';

  static Future<Map<String, String>?> getLocationFromPincode(
      String pincode) async {
    final Uri url = Uri.parse('$_baseUrl/$pincode');

    try {
      final response = await http.get(url);

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);

        if (responseData.isNotEmpty && responseData[0]['Status'] == 'Success') {
          List<dynamic> postOffices = responseData[0]['PostOffice'];
          if (postOffices.isNotEmpty) {
            return {
              'Name': postOffices[0]['Name'], // First post office name
              'State': postOffices[0]['State'], // State name
            };
          }
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return null;
  }
}
