import 'package:flutter/material.dart';
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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.building?.name ?? '');
    _numberController = TextEditingController(text: widget.building?.number ?? '');
    _complementController = TextEditingController(text: widget.building?.complement ?? '');
  }

  Future<void> _save() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isSaving = true);

    final buildingVM = context.read<BuildingViewModel>();
    final newBuilding = Building(
      name: _nameController.text,
      number: _numberController.text,
      complement: _complementController.text,
    );

    bool success;
    if (widget.building == null) {
      success = await buildingVM.createBuilding(newBuilding);
    } else {
      success = await buildingVM.updateBuilding(widget.building!.id!, newBuilding);
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
                ? const CircularProgressIndicator(color: Colors.white)
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
