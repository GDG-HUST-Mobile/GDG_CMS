// lib/core/utils/shared_prefs_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool getSeenState() {
    return _prefs.getBool('hasSeenWelcome') ?? false;
  }

}