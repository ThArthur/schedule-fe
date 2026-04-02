import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/building.dart';
import '../core/api_config.dart';

class BuildingViewModel extends ChangeNotifier {
  final String _baseUrl = '${ApiConfig.baseUrl}/buildings';
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

  Future<bool> createBuilding(Building building, File? imageFile) async {
    if (_token == null) return false;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      request.headers['Authorization'] = 'Bearer $_token';

      request.files.add(http.MultipartFile.fromString(
        'building',
        jsonEncode(building.toJson()),
        contentType: MediaType('application', 'json'),
      ));

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchBuildings();
        return true;
      }
    } catch (e) {
      debugPrint('Error creating building: $e');
    }
    return false;
  }

  Future<bool> updateBuilding(int id, Building building, File? imageFile) async {
    if (_token == null) return false;
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$_baseUrl/$id'));
      request.headers['Authorization'] = 'Bearer $_token';

      request.files.add(http.MultipartFile.fromString(
        'building',
        jsonEncode(building.toJson()),
        contentType: MediaType('application', 'json'),
      ));

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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
