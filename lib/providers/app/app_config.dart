import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  bool _isDark;
  bool _isLoggined;
  bool _isFirstTime;
  void Function() _notify;

  AppConfig(this._notify) {
    _isDark = false;
    _isLoggined = false;
    _isFirstTime = false;
    checkTheme();
    checkAuth();
  }

  bool get isLoggined => _isLoggined;

  set isLoggined(bool value) {
    _isLoggined = value;
  }
  bool get isFirstTime => _isFirstTime;

  set isFirstTime(bool value) {
    _isFirstTime = value;
  }

  bool get isDark => _isDark;

  set isDark(bool value) {
    _isDark = value;
    _notify();
    saveTheme();
  }

  Future<void> checkAuth() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null)
      isLoggined = true;
    else
      isLoggined = false;
  }

  void checkTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isDarkValue = sharedPreferences.getBool('isDark');
    isDark = isDarkValue?? false;
  }

  void saveTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('isDark', isDark);
  }
}
