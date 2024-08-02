import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:register/models/student_model.dart';
import 'package:register/screens/students/update_student_page.dart';
import 'package:register/screens/students/upload_image_page.dart';
import 'package:register/services/student_services.dart';

class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({super.key, required this.studentId});

  final int studentId;

  @override
  StudentDetailPageState createState() => StudentDetailPageState();
}

class StudentDetailPageState extends State<StudentDetailPage> {
  final _logger = Logger('StudentDetailPage');
  final StudentServices _studentService = StudentServices();
  late Future<Student?> _studentFuture;

  @override
  void initState() {
    super.initState();
    _studentFuture = _fetchStudent();
  }

  Future<Student?> _fetchStudent() async {
    try {
      return await _studentService.getStudentById(widget.studentId);
    } catch (e) {
      _logger.severe('Error fetching student: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    const TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Estudiante'),
      ),
      body: FutureBuilder<Student?>(
        future: _studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Student not found'));
          } else {
            final student = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const UploadImagePage(),
                            ),
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: student.imagePath != null
                            ? NetworkImage(
                                'http://localhost:8080/file/files/${student.imagePath}')
                            : null,
                        child: student.imagePath == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildBoldText('ID: ${student.id}', boldStyle),
                  _buildListTile('Nombre:', student.studentName, boldStyle),
                  _buildListTile('Apellido:', student.lastName, boldStyle),
                  _buildListTile('Fecha de nacimiento:',
                      dateFormat.format(student.birthDate), boldStyle),
                  _buildListTile('Fecha de registro:',
                      dateFormat.format(student.registrationDate), boldStyle),
                  _buildListTile(
                      'Fecha de finalización de registro:',
                      dateFormat.format(student.registrationEndDate),
                      boldStyle),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                FormStudentPage(student: student),
                          ),
                        );
                      }
                    },
                    child: const Text('Editar'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildBoldText(String text, TextStyle style) {
    return Text(text, style: style);
  }

  Widget _buildListTile(String title, String subtitle, TextStyle style) {
    return ListTile(
      title: Text(title, style: style),
      subtitle: Text(subtitle),
    );
  }
}
