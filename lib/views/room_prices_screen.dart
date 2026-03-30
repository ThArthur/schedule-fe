import 'package:flutter/material.dart';
import '../models/room.dart';

class RoomPricesScreen extends StatelessWidget {
  final Room room;

  const RoomPricesScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goldColor = theme.colorScheme.primary;

    // Como o modelo Room atual não tem preço nem imagem vindo do backend,
    // usamos valores padrão ou mockados para evitar erros de compilação.
    const double basePrice = 100.0;

    final List<Map<String, dynamic>> priceTiers = [
      {'label': 'Hora Avulsa', 'price': basePrice},
      {'label': 'Turno (4h)', 'price': basePrice * 3.5},
      {'label': 'Diária (8h)', 'price': basePrice * 6.0},
      {'label': 'Pacote Mensal (10h)', 'price': basePrice * 8.0},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tabela de Preços',
          style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.meeting_room_rounded, size: 40, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sala ${room.number}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${room.floor} - Gerenciamento de valores',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'VALORES CONFIGURADOS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: goldColor,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: priceTiers.length,
              itemBuilder: (context, index) {
                final tier = priceTiers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tier['label'],
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(
                        'R\$ ${tier['price'].toStringAsFixed(2)}',
                        style: TextStyle(
                          color: goldColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A1A),
                foregroundColor: goldColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('ADICIONAR NOVO PACOTE', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
