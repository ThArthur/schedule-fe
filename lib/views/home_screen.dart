import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../view_models/auth_view_model.dart';
import '../models/room.dart';
import 'dashboard_screen.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import 'edit_room_screen.dart';
import 'room_prices_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  int _selectedIndex = 0;

  // Fake Data
  final List<Room> _rooms = [
    Room(
      id: '1',
      name: 'Espaço Master Psique',
      description: 'Ambiente climatizado com poltronas ergonômicas.',
      pricePerHour: 120.0,
      imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=800',
    ),
    Room(
      id: '2',
      name: 'Consultório Ametista',
      description: 'Ideal para atendimentos individuais e terapias.',
      pricePerHour: 85.0,
      imageUrl: 'https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&q=80&w=800',
    ),
    Room(
      id: '3',
      name: 'Espaço Lounge VIP',
      description: 'Espaço amplo para pequenos grupos ou workshops.',
      pricePerHour: 200.0,
      imageUrl: 'https://images.unsplash.com/photo-1431540015161-0bf868a2d407?auto=format&fit=crop&q=80&w=800',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return _isLoading ? _buildShimmerLoading() : _buildRoomList();
      case 2:
        return const CalendarScreen();
      case 3:
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }

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
              'Olá, Administrador',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
            ),
            Text(
              'Psique Lounge Admin',
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
      body: _getBody(),
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
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.business_rounded), label: 'Espaços'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Agenda'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Config'),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 1 
        ? FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditRoomScreen()),
              );
            },
            backgroundColor: const Color(0xFF1A1A1A),
            foregroundColor: goldColor,
            child: const Icon(Icons.add),
          )
        : null,
    );
  }

  Widget _buildRoomList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _rooms.length,
      itemBuilder: (context, index) {
        final room = _rooms[index];
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
                child: Image.network(
                  room.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          room.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBFBFB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                          ),
                          child: Text(
                            'R\$ ${room.pricePerHour.toStringAsFixed(2)}/h',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      room.description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => EditRoomScreen(room: room)),
                              );
                            },
                            icon: const Icon(Icons.edit_rounded, size: 18),
                            label: const Text('EDITAR'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF1A1A1A),
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => RoomPricesScreen(room: room)),
                              );
                            },
                            icon: const Icon(Icons.visibility_rounded, size: 18),
                            label: const Text('PREÇOS'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A1A1A),
                              foregroundColor: Theme.of(context).colorScheme.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
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
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}
