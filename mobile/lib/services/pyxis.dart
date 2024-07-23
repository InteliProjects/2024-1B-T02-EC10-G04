import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/pyxis.dart';
import 'package:mobile/models/medicines.dart';
import 'package:mobile/logic/local_storage.dart';

class PyxisService{
  final String baseUrl = dotenv.env['PUCLIC_URL']!;
  String? accessToken;

  Future<Pyxis> getPyxisById(String id) async {
    try {
      accessToken = await LocalStorageService().getValue('access_token');
      final response = await http.get(
        Uri.parse('$baseUrl/pyxis/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Pyxis.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load Pyxis');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Medicines>> getMedicinesByPyxisId(String id) async {
    try {
      accessToken = await LocalStorageService().getValue('access_token');
      final response = await http.get(
        Uri.parse('$baseUrl/pyxis/$id/medicines'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((e) => Medicines.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load Medicines');
      }
    } catch (e) {
      throw Exception(e);
    }
  }


}