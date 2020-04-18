import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:students_app/consts.dart' as consts;
import 'package:students_app/models/student/student.dart';

//This class for student operations >>
class StudentModel {
  static StudentModel _studentModelInstance;

  static StudentModel getInstance() {
    if (_studentModelInstance != null) return _studentModelInstance;
    return _studentModelInstance = StudentModel();
  }

  Future<void> addStudent(Student student) async {
    await Firestore.instance
        .collection(consts.COLLECTION_STUDENTS)
        .document(student.email)
        .setData(student.asMap());
  }

  Future<void> deleteStudent(String email) async {
    await Firestore.instance
        .collection(consts.COLLECTION_STUDENTS)
        .document(email)
        .delete();
  }

  Future<void> updateStudent(String email, Student student) async {
    await Firestore.instance
        .collection(consts.COLLECTION_STUDENTS)
        .document(email)
        .setData(student.asMap());
  }

  Future<Student> getStudent(String email) async {
    DocumentSnapshot documentSnapshot = await Firestore.instance
        .collection(consts.COLLECTION_STUDENTS)
        .document(email)
        .get();
    return fromMap(documentSnapshot.data)..email = documentSnapshot.documentID;
  }

  Student fromMap(Map<String, dynamic> map) {
    return Student(
        name: map[consts.FIELD_NAME],
        phoneNumber: map[consts.FIELD_PHONE_NUMBER]);
  }

  Future<List<Student>> getAllStudents() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(consts.COLLECTION_STUDENTS)
        .orderBy(consts.FIELD_NAME)
        .getDocuments();
    return querySnapshot.documents.map<Student>((document) {
      return fromMap(document.data)..email = document.documentID;
    }).toList();
  }
}
