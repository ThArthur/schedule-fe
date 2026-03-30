import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/room.dart';
import '../widgets/custom_text_field.dart';

class EditRoomScreen extends StatefulWidget {
  final Room? room;

  const EditRoomScreen({super.key, this.room});

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room?.name ?? '');
    _descriptionController = TextEditingController(text: widget.room?.description ?? '');
    _priceController = TextEditingController(text: widget.room?.pricePerHour.toString() ?? '');
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _imageFile = File(selectedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goldColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.room == null ? 'Novo Espaço' : 'Editar Espaço',
          style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                  image: _imageFile != null
                      ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                      : (widget.room != null
                          ? DecorationImage(image: NetworkImage(widget.room!.imageUrl), fit: BoxFit.cover)
                          : null),
                ),
                child: _imageFile == null && widget.room == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_rounded, size: 40, color: goldColor),
                          const SizedBox(height: 8),
                          Text('Adicionar Foto do Espaço', style: TextStyle(color: Colors.grey[600])),
                        ],
                      )
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _nameController,
              label: 'Nome do Espaço',
              prefixIcon: Icons.business_rounded,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              label: 'Descrição',
              prefixIcon: Icons.description_rounded,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _priceController,
              label: 'Preço por Hora (R\$)',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.payments_rounded,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Lógica para salvar com o arquivo _imageFile
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                foregroundColor: goldColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                widget.room == null ? 'CRIAR ESPAÇO' : 'SALVAR ALTERAÇÕES',
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
