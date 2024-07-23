// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/logic/local_storage.dart';

class UserService {
  final String baseUrl = dotenv.env['PUCLIC_URL']!;
  final LocalStorageService localStorageService = LocalStorageService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      body['isOnboarding'] = true;
      for (var key in body.keys) {
        localStorageService.saveValue(key, body[key].toString());
      }
      return body;
    }
    return {};
  }

  Future<Map<String, dynamic>> signup(
      String name, String email, String password, String profession) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'name': name,
        'password': password,
        'profession': profession,
        'role': 'user',
      }),
    );

    if (response.statusCode == 201) {
      var body = jsonDecode(response.body);
      body['isOnboarding'] = true;
      for (var key in body.keys) {
        localStorageService.saveValue(key, body[key].toString());
      }
      return body;
    }
    return {};
  }

  Future<Map<String, dynamic>> updatePassword(String newPassword) async {
    var id = await localStorageService.getValue('id');
    var email = await localStorageService.getValue('email');
    var role = await localStorageService.getValue('role');
    var name = await localStorageService.getValue('name');

    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "email": email,
        "id": id,
        "name": name,
        "on_duty": true,
        "password": newPassword,
        "role": role
      }),
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return body;
    }
    return {};
  }

  Future<List> getAllUsers() async {
    var accessToken = await localStorageService.getValue('access_token');

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return body;
    }
    return [];
  }
}
