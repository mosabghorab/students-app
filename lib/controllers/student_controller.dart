import 'package:students_app/models/student/student.dart';
import 'package:students_app/models/student/student_model.dart';

//This class for controlling student operations >>
class StudentController {
  static StudentController _studentControllerInstance;

  // singleton pattern >>
  static StudentController getInstance() {
    if (_studentControllerInstance != null) return _studentControllerInstance;
    return _studentControllerInstance = StudentController();
  }

  // method for adding a student  >>
  Future<void> addStudent(Student student) async {
    return await StudentModel.getInstance().addStudent(student);
  }

  // method for deleting a student  >>
  Future<void> deleteStudent(String email) async {
    return await StudentModel.getInstance().deleteStudent(email);
  }

  // method for updating a student  >>
  Future<void> updateStudent(String email, Student student) async {
    return await StudentModel.getInstance().updateStudent(email, student);
  }

  // method for getting student data  >>
  Future<Student> getStudent(String email) async {
    return await StudentModel.getInstance().getStudent(email);
  }

  // method for getting all students  >>
  Future<List<Student>> getAllStudents() async {
    return await StudentModel.getInstance().getAllStudents();
  }
}
