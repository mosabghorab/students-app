import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:students_app/providers/student/student_config.dart';

class StudentProvider with ChangeNotifier {
  StudentConfig _studentConfig;

  StudentConfig get studentConfig => _studentConfig;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  StudentProvider() {
    _studentConfig =
        StudentConfig(() => notifyListeners());
  }
}
