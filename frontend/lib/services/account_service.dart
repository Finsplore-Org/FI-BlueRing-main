import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/account.dart';
import '../services/token_service.dart';

class AccountService {
  final String baseUrl = 'http://localhost:8080';
  final TokenService _tokenService = TokenService();

  Future<double?> getGoal() async {
    try {
      final userId = await _tokenService.getUserId();
      
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
        throw Exception('Fail fetch goal: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network disconnect: $e');
    }
  }

  Future<List<Account>> getAccounts() async {
    try {
      final userId = await _tokenService.getBasiqUserId();

      final response = await http.post(
        Uri.parse('$baseUrl/transactions/balance'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map(
              (json) => Account(
                id: json['id'].toString(),
                name: json['name'] ?? 'Account',
                balance:
                    double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
                monthOverMonthChange: 0,
              ),
            )
            .toList();
      } else {
        throw Exception('Failed to load accounts: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
