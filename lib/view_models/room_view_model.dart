import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/room.dart';

class RoomViewModel extends ChangeNotifier {
  static String get _host {
    if (kIsWeb) return 'localhost';
    try {
      if (Platform.isAndroid) return '192.168.15.7';
    } catch (_) {}
    return 'localhost';
  }

  final String _baseUrl = 'http://$_host:8090/api/rooms';
  List<Room> _rooms = [];
  bool _isLoading = false;
  String? _token;

  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;

  void updateToken(String? token) {
    _token = token;
  }

  Future<void> fetchRooms() async {
    if (_token == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _rooms = data.map((json) => Room.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching rooms: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Room> getRoomsByBuildingId(int buildingId) {
    return _rooms.where((room) => room.buildingId == buildingId).toList();
  }

  Future<bool> createRoom(Room room) async {
    if (_token == null) return false;
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(room.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchRooms();
        return true;
      }
    } catch (e) {
      debugPrint('Error creating room: $e');
    }
    return false;
  }

  Future<bool> updateRoom(int id, Room room) async {
    if (_token == null) return false;
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(room.toJson()),
      );

      if (response.statusCode == 200) {
        await fetchRooms();
        return true;
      }
    } catch (e) {
      debugPrint('Error updating room: $e');
    }
    return false;
  }

  Future<bool> deleteRoom(int id) async {
    if (_token == null) return false;
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _rooms.removeWhere((r) => r.id == id);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error deleting room: $e');
    }
    return false;
  }
}
