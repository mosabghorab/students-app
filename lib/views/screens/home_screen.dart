import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:students_app/models/student/student.dart';
import 'package:students_app/providers/app/app_provider.dart';
import 'package:students_app/providers/student/student_provider.dart';
import 'package:students_app/views/widgets/dialog_add_student.dart';
import 'package:students_app/views/widgets/dialog_edit_student.dart';
import 'package:students_app/consts.dart' as consts;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (context) => StudentProvider(),
        child: BotToastInit(child: HomeScreenBody()));
  }
}

class HomeScreenBody extends StatelessWidget {
  StudentProvider _studentProvider;
  AppProvider _appProvider;
  BuildContext _context;
  Student fromMap(Map<String, dynamic> map) {
    return Student(name: map['name'], phoneNumber: map['phoneNumber']);
  }

  Widget _buildListTile(snapshot, index) {
    print(index);
    Student student = snapshot[index];
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(_context, 'details', arguments: student.email);
        },
        title: Text(student.name),
        subtitle: Text(student.phoneNumber),
        leading: CircleAvatar(
          child: Text(student.name.substring(0, 1).toUpperCase()),
        ),
        trailing: SizedBox(
          width: 100,
          child: Center(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue[800],
                  ),
                  onPressed: () {
                    editStudentDialog(student.email);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[700],
                  ),
                  onPressed: () {
                    if (!_appProvider.appConfig.isLoggined) {
                      Navigator.pushNamed(_context, 'login');
                      return;
                    }
                    _studentProvider.studentConfig
                        .deleteStudent(student.email, index);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentsList(List<Student> snapshot) {
    return ListView.builder(
        itemCount: snapshot.length + 1,
        itemBuilder: (context, index) {
          return Center(
            child: index > 0
                ? _buildListTile(snapshot, index - 1)
                : _studentProvider.studentConfig.isLoading
                    ? LinearProgressIndicator()
                    : Container(),
          );
        });
  }

  void addStudentDialog() async {
    if (!_appProvider.appConfig.isLoggined) {
      Navigator.pushNamed(_context, 'login');
      return;
    }
    showDialog(
        context: _context,
        builder: (context) => DialogAddStudent(_studentProvider));
  }

  void editStudentDialog(String email) async {
    if (!_appProvider.appConfig.isLoggined) {
      Navigator.pushNamed(_context, 'login');
      return;
    }
    showDialog(
        context: _context,
        builder: (context) => EditStudentDialog(email, _studentProvider));
  }

  @override
  Widget build(BuildContext context) {
    _studentProvider = Provider.of<StudentProvider>(context);
    _appProvider = Provider.of<AppProvider>(context);
    _context = context;
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                if (!_appProvider.appConfig.isLoggined) {
                  Navigator.pushNamed(context, 'login');
                  return;
                }
                FirebaseAuth.instance.signOut();
                _appProvider.appConfig.checkAuth();
                Navigator.pushReplacementNamed(context, 'home');
              },
              child: Text(
                _appProvider.appConfig.isLoggined ? 'Log out' : 'Log in',
              ),
              textColor: Colors.white,
            ),
            Switch(
                value: _appProvider.appConfig.isDark,
                onChanged: (val) {
                  _appProvider.appConfig.isDark = val;
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addStudentDialog();
          },
          child: Icon(Icons.add),
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection(consts.COLLECTION_STUDENTS)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                _studentProvider.studentConfig.students =
                    snapshot.data.documents.map<Student>((document) {
                  return fromMap(document.data)..email = document.documentID;
                }).toList();

                return _studentProvider.studentConfig.students.isEmpty
                    ? Icon(
                        Icons.hourglass_empty,
                        size: 70,
                        color: Colors.grey,
                      )
                    : _buildStudentsList(
                        _studentProvider.studentConfig.students);
              } else if (snapshot.hasError) {
                return Icon(
                  Icons.error,
                  size: 60,
                  color: Colors.red,
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}
