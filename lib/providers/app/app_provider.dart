import 'package:flutter/cupertino.dart';
import 'package:students_app/providers/app/app_config.dart';

class AppProvider with ChangeNotifier {
  AppConfig _appConfig;

  AppConfig get appConfig => _appConfig;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  AppProvider() {
    _appConfig = AppConfig(() => notifyListeners());
  }
}
