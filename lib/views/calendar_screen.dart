import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note_rounded, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Agenda de Reservas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Visualize e gerencie os horários aqui.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
