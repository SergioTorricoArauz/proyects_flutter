import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../models/student_model.dart';

class StudentServices {
  final _logger = Logger('StudentServices');
  final client = http.Client();

  Future<List<Student>> getListStudents() async {
    const url = 'http://localhost:8080/student/list';
    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to load students');
      }

      final jsonResponse = jsonDecode(response.body);
      final students =
          (jsonResponse as List).map((item) => Student.fromJson(item)).toList();
      return students;
    } catch (e) {
      _logger.severe('Error fetching students: $e');
      rethrow;
    }
  }

  Future<Student> getStudentById(int id) async {
    final url = 'http://localhost:8080/student/list/$id';
    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to load student');
      }

      final jsonResponse = jsonDecode(response.body);
      final student = Student.fromJson(jsonResponse);
      return student;
    } catch (e) {
      _logger.severe('Error fetching student: $e');
      rethrow;
    }
  }

  Future<Student> createStudent(Student student) async {
    const url = 'http://localhost:8080/student/create';
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(student.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create student');
      }

      final jsonResponse = jsonDecode(response.body);
      final newStudent = Student.fromJson(jsonResponse);
      return newStudent;
    } catch (e) {
      _logger.severe('Error creating student: $e');
      rethrow;
    }
  }

  Future<Student> updateStudent(Student student) async {
    final url = 'http://localhost:8080/student/update/${student.id}';
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      final response = await client.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(student.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update student');
      }

      final jsonResponse = jsonDecode(response.body);
      final updatedStudent = Student.fromJson(jsonResponse);
      return updatedStudent;
    } catch (e) {
      _logger.severe('Error updating student: $e');
      rethrow;
    }
  }
}
