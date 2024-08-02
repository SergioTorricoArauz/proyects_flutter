import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:register/models/student_model.dart';
import 'package:register/services/student_services.dart';

class CreateStudentPage extends StatefulWidget {
  const CreateStudentPage({super.key});

  @override
  State<CreateStudentPage> createState() => CreateStudentPageState();
}

class CreateStudentPageState extends State<CreateStudentPage> {
  final _logger = Logger('StudentServices');
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthDateController;
  late TextEditingController _registrationDateController;
  late TextEditingController _registrationEndDateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _birthDateController = TextEditingController();
    _registrationDateController = TextEditingController();
    _registrationEndDateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _registrationDateController.dispose();
    _registrationEndDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectRegistrationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _registrationDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectRegistrationEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(5000),
    );
    if (picked != null) {
      setState(() {
        _registrationEndDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _createStudent() async {
    if (_formKey.currentState!.validate()) {
      // Crear una instancia del servicio
      final studentService = StudentServices();

      // Crear un nuevo objeto Student
      final newStudent = Student(
        studentName: _nameController.text,
        lastName: _lastNameController.text,
        birthDate: DateTime.parse(_birthDateController.text),
        registrationDate: DateTime.parse(_registrationDateController.text),
        registrationEndDate:
            DateTime.parse(_registrationEndDateController.text),
      );

      try {
        // Llamar al método de creación del servicio
        await studentService.createStudent(newStudent);

        // Verificar si el widget sigue montado antes de usar el contexto
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Estudiante creado exitosamente'),
          ),
        );

        // Navegar hacia la lista de estudiantes
        Navigator.pushReplacementNamed(context, '/students');
      } catch (e) {
        // Manejar errores de creación
        _logger.severe('Error creating student: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Estudiante'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _birthDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha de nacimiento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _registrationDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de inscripción',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectRegistrationDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha de inscripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _registrationEndDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de finalización de inscripción',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectRegistrationEndDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha de finalización de inscripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createStudent,
                child: const Text('Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
