import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import '../models/student_model.dart';

class StudentServices {
  final _logger = Logger('StudentServices');
  final ImagePicker picker = ImagePicker();
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

  Future<void> deleteStudent(int id) async {
    final url = 'http://localhost:8080/student/delete/$id';

    try {
      final response = await client.delete(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete student');
      }
    } catch (e) {
      _logger.severe('Error deleting student: $e');
      rethrow;
    }
  }

  Future<void> pickAndUploadImage(int studentId) async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      await uploadImage(image, studentId);
    } catch (e) {
      _logger.severe('Error al seleccionar o subir imagen: $e');
    }
  }

  Future<void> uploadImage(XFile imageFile, int studentId) async {
    final uri = Uri.parse(
        'http://localhost:8080/student/students/upload?id=$studentId');

    if (Uri.base.scheme == 'http' || Uri.base.scheme == 'https') {
      // Flutter Web
      final request = http.MultipartRequest('POST', uri)
        ..fields['id'] = studentId.toString()
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      try {
        final response = await request.send();

        if (response.statusCode == 200) {
          _logger.info('Imagen subida exitosamente');
        } else {
          _logger.severe('Error al subir imagen: ${response.statusCode}');
        }
      } catch (e) {
        _logger.severe('Error durante la subida de imagen: $e');
      }
    } else {
      // Flutter Mobile
      final request = http.MultipartRequest('POST', uri)
        ..fields['id'] = studentId.toString()
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      try {
        final response = await request.send();

        if (response.statusCode == 200) {
          _logger.info('Imagen subida exitosamente');
        } else {
          _logger.severe('Error al subir imagen: ${response.statusCode}');
        }
      } catch (e) {
        _logger.severe('Error durante la subida de imagen: $e');
      } finally {
        client.close();
      }
    }
  }
}
