import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart'; // 确保你引入了 TokenService

class WeeklyTransactionService {
  static const String baseUrl = 'http://localhost:8080';
  final TokenService _tokenService = TokenService();

  Future<List<Map<String, dynamic>>> getWeeklyTransactions() async {
    final userId = await _tokenService.getUserId();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions/user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId.toString()}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception(
          'Failed to load weekly transactions: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching weekly transactions: $e');
    }
  }

Future<List<Map<String, dynamic>>> getTransactionsByAccount(String accountId) async {
  final userId = await _tokenService.getUserId();
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions/account'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId.toString(),
        'account': accountId,
      }),
    );

    if (response.statusCode == 200) {
      // 直接把根解析成 List<dynamic>
      final List<dynamic> data = jsonDecode(response.body);
      // 转成 List<Map<String, dynamic>>
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception(
        'Failed to load account transactions: ${response.statusCode}',
      );
    }
  } catch (e) {
    throw Exception('Error fetching account transactions: $e');
  }
}

}
