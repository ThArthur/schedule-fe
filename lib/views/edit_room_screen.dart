import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/room.dart';
import '../view_models/room_view_model.dart';
import '../widgets/custom_text_field.dart';

class EditRoomScreen extends StatefulWidget {
  final Room? room;
  final int buildingId;

  const EditRoomScreen({super.key, this.room, required this.buildingId});

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  late TextEditingController _numberController;
  late TextEditingController _floorController;
  File? _image;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.room?.number ?? '');
    _floorController = TextEditingController(text: widget.room?.floor ?? '');
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
    if (_numberController.text.isEmpty) return;

    setState(() => _isSaving = true);

    final roomVM = context.read<RoomViewModel>();
    final roomData = Room(
      number: _numberController.text,
      floor: _floorController.text,
      buildingId: widget.buildingId,
    );

    bool success;
    if (widget.room == null) {
      success = await roomVM.createRoom(roomData, _image);
    } else {
      success = await roomVM.updateRoom(widget.room!.id!, roomData, _image);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar sala')),
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
          widget.room == null ? 'Nova Sala' : 'Editar Sala',
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
                        : (widget.room?.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(widget.room!.imageUrl!),
                                fit: BoxFit.cover)
                            : null),
                  ),
                  child: _image == null && widget.room?.imageUrl == null
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
              controller: _numberController,
              label: 'Número da Sala (ex: 101)',
              prefixIcon: Icons.meeting_room_rounded,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _floorController,
              label: 'Andar (ex: 1º Andar)',
              prefixIcon: Icons.layers_rounded,
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
                    widget.room == null ? 'CRIAR SALA' : 'SALVAR ALTERAÇÕES',
                    style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
            ),
            if (widget.room != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () async {
                  final success = await context.read<RoomViewModel>().deleteRoom(widget.room!.id!);
                  if (success && mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text('EXCLUIR SALA', style: TextStyle(color: Colors.red)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
