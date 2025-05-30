import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class BudgetService {
  static const String baseUrl = 'http://localhost:8080';
  final TokenService _tokenService = TokenService();

  Future<bool> setBudget(double amount) async {
    final userId = await _tokenService.getUserId();
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/budget/set'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'amount': amount
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to set budget: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error setting budget: $e');
    }
  }

  Future<double?> getBudget() async {
    final userId = await _tokenService.getUserId();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/budget/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['amount'];
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get budget: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching budget: $e');
    }
  }
}