import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:register/models/student_model.dart';
import 'package:register/services/student_services.dart';

class FormStudentPage extends StatefulWidget {
  final Student student;

  const FormStudentPage({super.key, required this.student});

  @override
  FormStudentPageState createState() => FormStudentPageState();
}

class FormStudentPageState extends State<FormStudentPage> {
  final _logger = Logger('StudentServices');
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthDateController;
  late TextEditingController _registrationDate;
  late TextEditingController _registrationEndDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.studentName);
    _lastNameController = TextEditingController(text: widget.student.lastName);
    _birthDateController = TextEditingController(
        text: widget.student.birthDate.toString().split(' ')[0]);
    _registrationDate = TextEditingController(
        text: widget.student.registrationDate.toString().split(' ')[0]);
    _registrationEndDate = TextEditingController(
        text: widget.student.registrationEndDate.toString().split(' ')[0]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _registrationDate.dispose();
    _registrationEndDate.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.student.birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != widget.student.birthDate) {
      setState(() {
        _birthDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectRegistrationDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.student.registrationDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != widget.student.registrationDate) {
      setState(() {
        _registrationDate.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectRegistrationEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.student.registrationEndDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != widget.student.registrationEndDate) {
      setState(() {
        _registrationEndDate.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      // Crear una instancia del servicio
      final studentService = StudentServices();

      // Actualizar el objeto Student con los nuevos valores
      widget.student.studentName = _nameController.text;
      widget.student.lastName = _lastNameController.text;
      widget.student.birthDate = DateTime.parse(_birthDateController.text);
      widget.student.registrationDate = DateTime.parse(_registrationDate.text);
      widget.student.registrationEndDate =
          DateTime.parse(_registrationEndDate.text);

      try {
        // Llamar al método de actualización del servicio
        await studentService.updateStudent(widget.student);

        // Verificar si el widget sigue montado antes de usar el contexto
        if (!mounted) return;

        // Navegar hacia atrás después de la actualización exitosa
        Navigator.of(context).pop();
      } catch (e) {
        // Manejar errores de actualización
        _logger.severe('Error updating student: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Estudiante'),
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
                controller: _registrationDate,
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
                controller: _registrationEndDate,
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
                onPressed: _saveStudent,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
