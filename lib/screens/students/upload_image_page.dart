import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register/services/student_services.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  String? _imageUrl;
  final StudentServices _studentServices = StudentServices();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _studentServices.picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageUrl = pickedFile.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_imageUrl == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final file = XFile(_imageUrl!);
      await _studentServices.uploadImage(file, 152);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen subida exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir imagen: $e')),
        );
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subir Imagen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageUrl == null
                ? const Text('No se ha seleccionado ninguna imagen.')
                : SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(_imageUrl!),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Seleccionar Imagen'),
            ),
            const SizedBox(height: 20),
            _isUploading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadImage,
                    child: const Text('Subir Imagen'),
                  ),
          ],
        ),
      ),
    );
  }
}
