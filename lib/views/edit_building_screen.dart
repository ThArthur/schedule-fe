import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/building.dart';
import '../view_models/building_view_model.dart';
import '../widgets/custom_text_field.dart';

class EditBuildingScreen extends StatefulWidget {
  final Building? building;

  const EditBuildingScreen({super.key, this.building});

  @override
  State<EditBuildingScreen> createState() => _EditBuildingScreenState();
}

class _EditBuildingScreenState extends State<EditBuildingScreen> {
  late TextEditingController _nameController;
  late TextEditingController _numberController;
  late TextEditingController _complementController;
  File? _image;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.building?.name ?? '');
    _numberController = TextEditingController(text: widget.building?.number ?? '');
    _complementController = TextEditingController(text: widget.building?.complement ?? '');
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isSaving = true);

    final buildingVM = context.read<BuildingViewModel>();
    final buildingData = Building(
      name: _nameController.text,
      number: _numberController.text,
      complement: _complementController.text,
    );

    bool success;
    if (widget.building == null) {
      success = await buildingVM.createBuilding(buildingData, _image);
    } else {
      success = await buildingVM.updateBuilding(widget.building!.id!, buildingData, _image);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar prédio')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final goldColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.building == null ? 'Novo Prédio' : 'Editar Prédio',
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
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                    image: _image != null
                        ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover)
                        : (widget.building?.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(widget.building!.imageUrl!),
                                fit: BoxFit.cover)
                            : null),
                  ),
                  child: _image == null && widget.building?.imageUrl == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey[600]),
                            const SizedBox(height: 8),
                            Text('Adicionar Foto', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          ],
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _nameController,
              label: 'Nome do Prédio',
              prefixIcon: Icons.business_rounded,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _numberController,
              label: 'Número',
              prefixIcon: Icons.numbers_rounded,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _complementController,
              label: 'Complemento',
              prefixIcon: Icons.location_on_rounded,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                foregroundColor: goldColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isSaving 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(
                    widget.building == null ? 'CRIAR PRÉDIO' : 'SALVAR ALTERAÇÕES',
                    style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
            ),
            if (widget.building != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () async {
                  final success = await context.read<BuildingViewModel>().deleteBuilding(widget.building!.id!);
                  if (success && mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text('EXCLUIR PRÉDIO', style: TextStyle(color: Colors.red)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
