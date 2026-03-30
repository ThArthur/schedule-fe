import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goldColor = theme.colorScheme.primary;
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${authViewModel.userName ?? "Usuário"}',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
            ),
            Text(
              'Psique Lounge',
              style: theme.textTheme.bodySmall?.copyWith(color: goldColor, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1A1A1A)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF1A1A1A)),
            onPressed: () => authViewModel.logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _getBody(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: goldColor,
          unselectedItemColor: Colors.grey[400],
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Início'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Meus Agendamentos'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return _buildUserDashboard();
      case 1:
        return const Center(child: Text('Tela de Agendamentos do Usuário'));
      case 2:
        return const Center(child: Text('Tela de Perfil do Usuário'));
      default:
        return _buildUserDashboard();
    }
  }

  Widget _buildUserDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bem-vindo!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A1A), Color(0xFF333333)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reserve seu espaço agora',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Encontre o ambiente perfeito para o seu atendimento.',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('VER ESPAÇOS DISPONÍVEIS'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Próximos Agendamentos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text('Você não possui agendamentos futuros.', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}
