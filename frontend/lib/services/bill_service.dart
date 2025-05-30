import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class BillService {
  static const String baseUrl = 'http://localhost:8080';
  final TokenService _tokenService = TokenService();

  Future<Map<String, dynamic>> createBill(String name, double amount, String date) async {
    final userId = await _tokenService.getUserId();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/bills/set'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'name': name,
          'amount': amount,
          'date': date
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create bill: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while creating bill: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllBills() async {
    final userId = await _tokenService.getUserId();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/bills/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to retrieve bills: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while retrieving bills: $e');
    }
  }

  Future<void> deleteBill(int billId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/bills/delete/$billId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete bill: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while deleting bill: $e');
    }
  }
}