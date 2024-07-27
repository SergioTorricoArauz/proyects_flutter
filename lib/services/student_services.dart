import 'dart:convert';
import 'package:register/models/Student.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

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
}
