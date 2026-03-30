import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goldColor = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Visão Geral',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildStatCard('Agendamentos', '12', Icons.calendar_today_rounded, goldColor)),
              const SizedBox(width: 15),
              Expanded(child: _buildStatCard('Faturamento', 'R\$ 1.450', Icons.payments_rounded, goldColor)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildStatCard('Espaços Ativos', '5', Icons.business_rounded, goldColor)),
              const SizedBox(width: 15),
              Expanded(child: _buildStatCard('Novos Clientes', '8', Icons.person_add_rounded, goldColor)),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Atividade Recente',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 15),
          _buildActivityItem('João Silva reservou o Espaço Master', 'Há 10 minutos'),
          _buildActivityItem('Maria Oliveira cancelou o agendamento', 'Há 25 minutos'),
          _buildActivityItem('Pagamento confirmado: Espaço Ametista', 'Há 1 hora'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 15),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Color(0xFFD4AF37), shape: BoxShape.circle),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A))),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
