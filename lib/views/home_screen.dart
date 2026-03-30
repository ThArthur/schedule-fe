import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../view_models/building_view_model.dart';
import '../view_models/auth_view_model.dart';
import '../view_models/room_view_model.dart';
import '../models/building.dart';
import 'dashboard_screen.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import 'building_rooms_screen.dart';
import 'edit_building_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BuildingViewModel>().fetchBuildings();
      context.read<RoomViewModel>().fetchRooms();
    });
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return Consumer<BuildingViewModel>(
          builder: (context, buildingVM, _) {
            if (buildingVM.isLoading) return _buildShimmerLoading();
            return _buildBuildingList(buildingVM.buildings);
          },
        );
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
            BottomNavigationBarItem(icon: Icon(Icons.business_rounded), label: 'Prédios'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Agenda'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Config'),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 1 
        ? FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditBuildingScreen()),
              );
            },
            backgroundColor: const Color(0xFF1A1A1A),
            foregroundColor: goldColor,
            child: const Icon(Icons.add),
          )
        : null,
    );
  }

  Widget _buildBuildingList(List<Building> buildings) {
    if (buildings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('Nenhum prédio cadastrado', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<BuildingViewModel>().fetchBuildings(),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: buildings.length,
        itemBuilder: (context, index) {
          final building = buildings[index];
          final roomsCount = context.watch<RoomViewModel>().getRoomsByBuildingId(building.id!).length;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BuildingRoomsScreen(building: building)),
              );
            },
            child: Container(
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
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: const Icon(Icons.business_rounded, size: 40, color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                building.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFBFBFB),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                              ),
                              child: Text(
                                '$roomsCount Salas',
                                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${building.number}, ${building.complement}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => EditBuildingScreen(building: building)),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF1A1A1A),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('EDITAR'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => BuildingRoomsScreen(building: building)),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1A1A1A),
                                  foregroundColor: Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('VER SALAS'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
            height: 250,
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
