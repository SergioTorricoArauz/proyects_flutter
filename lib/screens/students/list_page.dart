import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:register/models/student_model.dart';
import 'package:register/services/student_services.dart';
import 'package:register/screens/students/detail_page.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  StudentListPageState createState() => StudentListPageState();
}

class StudentListPageState extends State<StudentListPage> {
  final _logger = Logger('StudentServices');
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

  Future<void> _deleteStudent(int studentId) async {
    try {
      await _studentService.deleteStudent(studentId);
      // After successful deletion, refresh the student list
      if (mounted) {
        _fetchStudents();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estudiante eliminado exitosamente')),
        );
      }
    } catch (e) {
      _logger.severe('Error deleting student: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el estudiante')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Estudiantes'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    final student = _students[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentDetailPage(studentId: student.id ?? 0),
                          ),
                        );
                      },
                      child: Card(
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
                                  '${student.studentName} ${student.lastName}'),
                              Row(
                                children: [
                                  const Spacer(), // Empuja el botón hacia el extremo derecho
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      // Show a confirmation dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Confirmar eliminación'),
                                            content: const Text(
                                                '¿Estás seguro de que deseas eliminar este estudiante?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _deleteStudent(
                                                      student.id ?? 0);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Eliminar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
