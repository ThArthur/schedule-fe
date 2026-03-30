import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/building.dart';

class BuildingViewModel extends ChangeNotifier {
  static String get _host {
    if (kIsWeb) return 'localhost';
    try {
      if (Platform.isAndroid) return '192.168.15.7';
    } catch (_) {}
    return 'localhost';
  }

  final String _baseUrl = 'http://$_host:8090/api/buildings';
  List<Building> _buildings = [];
  bool _isLoading = false;
  String? _token;

  List<Building> get buildings => _buildings;
  bool get isLoading => _isLoading;

  void updateToken(String? token) {
    _token = token;
  }

  Future<void> fetchBuildings() async {
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
        _buildings = data.map((json) => Building.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching buildings: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createBuilding(Building building) async {
    if (_token == null) return false;
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(building.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchBuildings();
        return true;
      }
    } catch (e) {
      debugPrint('Error creating building: $e');
    }
    return false;
  }

  Future<bool> updateBuilding(int id, Building building) async {
    if (_token == null) return false;
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(building.toJson()),
      );

      if (response.statusCode == 200) {
        await fetchBuildings();
        return true;
      }
    } catch (e) {
      debugPrint('Error updating building: $e');
    }
    return false;
  }

  Future<bool> deleteBuilding(int id) async {
    if (_token == null) return false;
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _buildings.removeWhere((b) => b.id == id);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error deleting building: $e');
    }
    return false;
  }
}
