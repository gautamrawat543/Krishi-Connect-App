// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String _apiKey =
//       'd0b45f7286msh5d58d52fe14f322p18cd38jsn617a70b1617c';
//   // static const String _apiHost =
//   //     'india-pincode-with-latitude-and-longitude.p.rapidapi.com';
//   static const String _apiHost = 'india-pincode-api.p.rapidapi.com';
//   // static const String _baseUrl = 'https://$_apiHost/api/v1/pincode';
//   static const String _baseUrl = 'https://$_apiHost/v1/in/places/pincode';

//   static Future<Map<String, String>?> getLocationFromPincode(
//       String pincode) async {
//     final Uri url = Uri.parse('$_baseUrl?pincode=$pincode');

//     final response = await http.get(
//       url,
//       headers: {
//         'x-rapidapi-key': _apiKey,
//         'x-rapidapi-host': _apiHost,
//       },
//     );

//     print('-------------11--${response.body}');

//     if (response.statusCode == 200) {
//       // List<dynamic> data = jsonDecode(response.body);
//       Map<String, dynamic> responseData = jsonDecode(response.body);
//       print('-------------12-----$responseData');
//       List<dynamic> data = responseData['result']; // Extract the list
//       if (responseData.containsKey('result')) {

//         if(data.isNotEmpty){
//         return {
//           'placename': data[0]['placename'], // City
//           'statename': data[0]['statename'],
//         };
//       }
//       }

//     }
//     return null;
//   }
// }

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
