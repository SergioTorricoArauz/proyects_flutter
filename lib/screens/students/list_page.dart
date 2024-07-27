import 'package:flutter/material.dart';
import 'package:register/models/Student.dart';
import 'package:register/services/student_services.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  StudentListPageState createState() => StudentListPageState();
}

class StudentListPageState extends State<StudentListPage> {
  final StudentServices _studentService = StudentServices();
  List<Student> _students = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final students = await _studentService.getListStudents();
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching students: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    final student = _students[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: ${student.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                                'Name: ${student.studentName} ${student.lastName}'),
                            Text('Birth Date: ${student.birthDate.toLocal()}'),
                            Text(
                                'Registration Date: ${student.registrationDate.toLocal()}'),
                            Text(
                                'Registration End Date: ${student.registrationEndDate.toLocal()}'),
                            if (student.imagePath.isNotEmpty)
                              if (student.imagePath.isNotEmpty)
                                Image.network(
                                  'http://localhost:8080/file/files/${student.imagePath}',
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text('Error loading image');
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    // Imprimir la URL de la imagen en la consola
                                    print(
                                        'Obteniendo imagen de: ${student.imagePath}');

                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    );
                                  },
                                )
                              else
                                const Text('No image available'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
