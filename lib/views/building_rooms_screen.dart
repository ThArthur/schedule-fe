import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/building.dart';
import '../models/room.dart';
import '../view_models/room_view_model.dart';
import '../core/api_config.dart';
import 'edit_room_screen.dart';
import 'room_prices_screen.dart';

class BuildingRoomsScreen extends StatelessWidget {
  final Building building;

  const BuildingRoomsScreen({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goldColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              building.name,
              style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold, fontSize: 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Gerenciar Salas',
              style: TextStyle(color: goldColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: Color(0xFF1A1A1A)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditRoomScreen(buildingId: building.id!),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<RoomViewModel>(
        builder: (context, roomVM, _) {
          final rooms = roomVM.getRoomsByBuildingId(building.id!);
          
          if (roomVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (rooms.isEmpty) {
            return _buildEmptyState(context, goldColor);
          }

          return RefreshIndicator(
            onRefresh: () => roomVM.fetchRooms(),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                return _buildRoomCard(context, room, goldColor);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color goldColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.meeting_room_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Nenhuma sala cadastrada',
            style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditRoomScreen(buildingId: building.id!),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A),
              foregroundColor: goldColor,
            ),
            child: const Text('CADASTRAR PRIMEIRA SALA'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, Room room, Color goldColor) {
    final formattedImageUrl = ApiConfig.formatImageUrl(room.imageUrl);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: (formattedImageUrl != null && formattedImageUrl.isNotEmpty)
                ? Image.network(
                    formattedImageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey[100],
                      child: const Icon(Icons.broken_image_rounded, size: 40, color: Colors.grey),
                    ),
                  )
                : Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: const Icon(Icons.meeting_room_rounded, size: 40, color: Colors.grey),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Sala ${room.number}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      room.floor,
                      style: TextStyle(color: goldColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditRoomScreen(room: room, buildingId: room.buildingId),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Editar', style: TextStyle(color: Color(0xFF1A1A1A))),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // RoomPricesScreen ainda usa o modelo antigo com pricePerHour, 
                          // podemos ajustar isso depois se o backend tiver preços
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A1A),
                          foregroundColor: goldColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Preços'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
