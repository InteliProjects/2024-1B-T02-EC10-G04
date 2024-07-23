import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/new_order.dart';

class NewOrderService {
  final String baseUrl = "http://10.254.19.182/api/v1";
  final String accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJJbnRlbGlNb2x1bG8xMCIsInN1YiI6IjQ3Yzk1NmM2LTIxMGEtNGU2My04ZDEyLWMwMTJlZGMxZjFhMCIsImV4cCI6MTcxNjc3NjA1OX0.EWSuAKHOH0SYBAvMmgSaz2I2gkVApo8ICHh_SuFzjhg";

  Future<NewOrder> createOrder(NewOrder newOrder) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/new-orders'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(newOrder.toJson()),
      );

      if (response.statusCode == 201) {
        return NewOrder.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create new order');
      }
    } catch (e) {
      throw Exception('Failed to create new order: $e');
    }
  }
}
