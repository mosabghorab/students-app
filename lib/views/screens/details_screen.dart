import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:students_app/providers/student/student_provider.dart';

class DetailsScreen extends StatelessWidget {
   String _email;

  @override
  Widget build(BuildContext context) {
    _email = ModalRoute.of(context).settings.arguments.toString();
    return ChangeNotifierProvider(
        builder: (context) => StudentProvider(),
        child: DetailsScreenBody(_email));
  }
}

class DetailsScreenBody extends StatelessWidget {
  String _email;
  StudentProvider _studentProvider;

  DetailsScreenBody(this._email);

  @override
  Widget build(BuildContext context) {
    _studentProvider = Provider.of<StudentProvider>(context);
    if (_studentProvider.studentConfig.isFirstTime) {
      _studentProvider.studentConfig.getStudent(_email);
      _studentProvider.studentConfig.isFirstTime = false;
    }
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: Center(
          child: Container(
            child: _studentProvider.studentConfig.student == null &&
                    !_studentProvider.studentConfig.isError
                ? CircularProgressIndicator()
                : _studentProvider.studentConfig.isError
                    ? Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 60,
                      )
                    : ListView(
                        children: <Widget>[
                          Card(
                            child: ListTile(
                              title: Text('Email'),
                              subtitle: Text(
                                  _studentProvider.studentConfig.student.email),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title: Text('Name'),
                              subtitle: Text(
                                  _studentProvider.studentConfig.student.name),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title: Text('Phone number'),
                              subtitle: Text(_studentProvider
                                  .studentConfig.student.phoneNumber),
                            ),
                          )
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
