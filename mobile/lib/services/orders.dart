import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/logic/local_storage.dart';
import 'package:mobile/models/order.dart';

class OrderService {
  final String baseUrl = dotenv.env['PUCLIC_URL']!;
  String? accessToken;
  String? id;
  String? role;
  List<Order> orders = [];
  List<Order> userOrders = [];

  Future<List<Order>> getOrders() async {
    // ignore: prefer_typing_uninitialized_variables
    try {
      role = await LocalStorageService().getValue('role');
      var accessToken = await LocalStorageService().getValue('access_token');

      var finalUrl = '$baseUrl/orders';

      switch (role) {
        case "user":
          finalUrl = '$baseUrl/orders/user';
        case "collector":
          finalUrl = '$baseUrl/orders/collector';
          break;
      }

      var response = await http.get(
        Uri.parse(finalUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonResponse = json.decode(response.body);
        orders = jsonResponse.map((order) => Order.fromJson(order)).toList();
        return orders;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<Map<String, dynamic>> createOrder(
      List<String> medicineIds, String observation, String pyxis) async {
    var accessToken = await LocalStorageService().getValue('access_token');
    var id = await LocalStorageService().getValue('id');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          "medicine_ids": medicineIds,
          "user_id": id,
          "observation":
              observation == "" ? "Order without comments" : observation,
          "on_duty": true,
          "quantity": 1,
          "priority": "green",
          "pyxis_id": pyxis,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return body;
      } else {
        throw Exception(
            'Failed to create order, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<Map<String, dynamic>> updateOrder(
      String orderId, String status) async {
    try {
      var accessToken = await LocalStorageService().getValue('access_token');
      final response = await http.put(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          "status": status,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return body;
      } else {
        throw Exception(
            'Failed to create order, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<Map<String, dynamic>> assignOrder(
      String orderId, String userId, String priority) async {
    try {
      var accessToken = await LocalStorageService().getValue('access_token');
      final response = await http.put(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
            <String, dynamic>{"priority": priority, "responsible_id": orderId}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return body;
      } else {
        throw Exception(
            'Failed to create order, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }
}
