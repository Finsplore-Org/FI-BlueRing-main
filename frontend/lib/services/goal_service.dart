import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class GoalService {
  static const String baseUrl = 'http://localhost:8080';
  final TokenService _tokenService = TokenService();

  Future<bool> setGoal(double amount) async {
    final userId = await _tokenService.getUserId();
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/api/goal/set'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'amount': amount
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to set goal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error setting goal: $e');
    }
  }

  Future<double?> getGoal() async {
    final userId = await _tokenService.getUserId();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/goal/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['amount'];
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get goal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching goal: $e');
    }
  }
}