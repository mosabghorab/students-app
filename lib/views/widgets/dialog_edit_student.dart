import 'package:flutter/material.dart';
import 'package:students_app/controllers/student_controller.dart';
import 'package:students_app/models/student/student.dart';
import 'package:students_app/providers/student/student_provider.dart';

class EditStudentDialog extends StatefulWidget {
  final String _email;
  final StudentProvider _studentProvider;

  EditStudentDialog(this._email, this._studentProvider);

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<EditStudentDialog> {
  GlobalKey<FormState> _editStudentFormKey;
  TextEditingController _nameController;
  TextEditingController _phoneNumberController;
  String _name, _phoneNumber, initName, initPhoneNumber;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _editStudentFormKey = GlobalKey();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    StudentController.getInstance().getStudent(widget._email).then((student) {
      setState(() {
        isLoading = false;
        _nameController.text = student.name;
        _phoneNumberController.text = student.phoneNumber;
        initPhoneNumber = student.phoneNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('dialog');
    return AlertDialog(
      title: Text('Edit student'),
      content: Container(
        height: isLoading
            ? MediaQuery.of(context).size.height * 0.11
            : MediaQuery.of(context).size.height * 0.21,
        width: MediaQuery.of(context).size.width,
        child: Form(
            key: _editStudentFormKey,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Center(
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Container()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isLoading ? Text('wait...') : Container(),
                    ),
                  ],
                ),
                isLoading
                    ? Container()
                    : TextFormField(
                        controller: _nameController,
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
                isLoading
                    ? Container()
                    : TextFormField(
                        controller: _phoneNumberController,
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
              if (_editStudentFormKey.currentState.validate()) {
                Navigator.pop(context);
                _editStudentFormKey.currentState.save();
                widget._studentProvider.studentConfig.updateStudent(
                    widget._email,
                    Student(
                      name: _name,
                      phoneNumber: _phoneNumber,
                    ));
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
