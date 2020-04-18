import 'package:flutter/material.dart';
import 'package:students_app/models/student/student.dart';
import 'package:students_app/providers/student/student_provider.dart';

class DialogAddStudent extends StatefulWidget {
  final StudentProvider _studentProvider;

  DialogAddStudent(this._studentProvider);

  @override
  _DialogAddStudentState createState() => _DialogAddStudentState();
}

class _DialogAddStudentState extends State<DialogAddStudent> {
  GlobalKey<FormState> _addStudentFormKey;
  String _email, _phoneNumber, _name;

  @override
  void initState() {
    super.initState();
    _addStudentFormKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add new student'),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Form(
            key: _addStudentFormKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.text,
                  onSaved: (value) => _name = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please fill name field';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Enter your name'),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _email = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please fill email field';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Enter your email'),
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => _phoneNumber = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please fill phone number field';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Enter your phone number'),
                )
              ],
            )),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (_addStudentFormKey.currentState.validate()) {
                Navigator.pop(context);
                _addStudentFormKey.currentState.save();
                widget._studentProvider.studentConfig.addStudent(Student(
                    name: _name, phoneNumber: _phoneNumber, email: _email));
              }
            },
            child: Text('OK')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),
      ],
    );
  }
}
