import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:students_app/controllers/student_controller.dart';
import 'package:students_app/models/student/student.dart';

class StudentConfig {
  List<Student> _students;
  Student _student;
  bool _isLoading;
  bool _isError;
  bool _isFirstTime;
  StudentController _studentController;
  ResultMessage _message;
  void Function() _notify;

  StudentConfig(
    this._notify,
  ) {
    _studentController = StudentController.getInstance();
    _isLoading = false;
    _isError = false;
    _isFirstTime = true;
  }

  Student get student => _student;

  set student(Student value) {
    _student = value;
    _notify();
  }

  List<Student> get students => _students;

  set students(List<Student> value) {
    _students = value;
  }

  ResultMessage get message => _message;

  bool get isLoading => _isLoading;

  bool get isError => _isError;

  bool get isFirstTime => _isFirstTime;

  set isFirstTime(bool value) {
    _isFirstTime = value;
  }

  set isLoading(bool value) {
    _isLoading = value;
    _notify();
  }

  Future<void> addStudent(Student student) async {
    isLoading = true;
    try {
      await _studentController.addStudent(student);
      _message = ResultMessage(
          'Student added successfully', ResultMessageType.SUCCESS);
    } catch (error) {
      _message = ResultMessage(error.message, ResultMessageType.FAILED);
    }
    isLoading = false;
    showMessage();
  }

  Future<void> deleteStudent(String email, int index) async {
    isLoading = true;
    try {
      await _studentController.deleteStudent(email);
      _message = ResultMessage(
          'Student deleted successfully', ResultMessageType.SUCCESS);
    } catch (error) {
      _message = ResultMessage(error.message, ResultMessageType.FAILED);
    }
    isLoading = false;
    showMessage();
  }

  Future<void> updateStudent(String email, Student student) async {
    isLoading = true;
    try {
      await _studentController.updateStudent(email, student);
      _message = ResultMessage(
          'Student updated successfully', ResultMessageType.SUCCESS);
    } catch (error) {
      _message = ResultMessage(error.message, ResultMessageType.FAILED);
    }
    isLoading = false;
    showMessage();
  }

  Future<void> getStudent(String email) async {
    try {
      student = await _studentController.getStudent(email);
    } catch (error) {
      _message = ResultMessage(error.message, ResultMessageType.FAILED);
      _isError = true;
      student = null;
    }
    showMessage();
  }

  void showMessage() {
    if (_message == null) return;
    String messageTitle = _message.content;
    if (_message.resultMessageType == ResultMessageType.SUCCESS)
      BotToast.showNotification(
          trailing: (_) => Icon(
                Icons.arrow_forward_ios,
                color: Colors.green,
              ),
          title: (_) =>
              Text('SUCCESS !!', style: TextStyle(color: Colors.green)),
          subtitle: (_) =>
              Text(messageTitle, style: TextStyle(color: Colors.green)),
          leading: (_) => Icon(
                Icons.assignment_turned_in,
                color: Colors.green,
              ));
    else
      BotToast.showNotification(
          trailing: (_) => Icon(
                Icons.arrow_forward_ios,
                color: Colors.red,
              ),
          title: (_) => Text('FAILED !!', style: TextStyle(color: Colors.red)),
          subtitle: (_) =>
              Text(messageTitle, style: TextStyle(color: Colors.red)),
          leading: (_) => Icon(
                Icons.error,
                color: Colors.red,
              ));
    _message = null;
  }
}

class ResultMessage {
  String _content;

  ResultMessageType _resultMessageType;

  ResultMessage(this._content, this._resultMessageType);

  ResultMessageType get resultMessageType => _resultMessageType;

  set resultMessageType(ResultMessageType value) {
    _resultMessageType = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }
}

enum ResultMessageType { FAILED, SUCCESS }
