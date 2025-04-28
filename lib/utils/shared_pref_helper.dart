import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences (call this in main() before runApp)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save Registration Status
  static Future<void> setRegistered(bool value) async {
    await _prefs?.setBool('isRegistered', value);
  }

  // Get Registration Status
  static bool isRegistered() {
    return _prefs?.getBool('isRegistered') ?? false;
  }

  // Save Username
  static Future<void> setUsername(String username) async {
    await _prefs?.setString('username', username);
  }

  // Get Username
  static String getUsername() {
    return _prefs?.getString('username') ?? 'Guest';
  }

  // Save Userrole
  static Future<void> setUserrole(String userrole) async {
    await _prefs?.setString('userrole', userrole);
  }

  // Get Userrole
  static String getUserrole() {
    return _prefs?.getString('userrole') ?? 'FARMER';
  }

  // Save Token
  static Future<void> setToken(String token) async {
    await _prefs?.setString('token', token);
  }

  // Get Token
  static String getToken() {
    return _prefs?.getString('token') ?? '';
  }

  // Save userId
  static Future<void> setUserId(String userId) async {
    await _prefs?.setString('userId', userId);
  }

  // Get userId
  static String getUserId() {
    return _prefs?.getString('userId') ?? '';
  }

  // Save Location
  static Future<void> setLocation(String location) async {
    await _prefs?.setString('location', location);
  }

  // Get Location
  static String getLocation() {
    return _prefs?.getString('location') ?? '';
  }

  // Clear All Data
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
