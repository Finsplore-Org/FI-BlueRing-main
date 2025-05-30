import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class CategoryService {
  final TokenService _tokenService = TokenService();
  final String baseUrl = 'http://localhost:8080';

  Future<List<Map<String, dynamic>>> getTopCategories() async {
    final userId = await _tokenService.getUserId();

    final response = await http.post(
      Uri.parse('$baseUrl/transactions/top-categories'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'userId': userId}),
    );
    
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> categories = jsonResponse['categories'];
      return categories.map((item) => {
        'name': item['category'],
        'amount': item['totalAmount'],
        'type': item['category'] == 'Income' ? 'INCOME' : 'SPENDING'
      }).toList();
    } else {
      throw Exception('Failed to load top categories');
    }
  }

  Future<List<Map<String, dynamic>>> getTopCategoriesByAccount(String accountId) async {
    final userId = await _tokenService.getUserId();

    final response = await http.post(
      Uri.parse('$baseUrl/transactions/top-categories/account'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'userId': userId,
        'account': accountId
      }),
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> categories = jsonResponse['categories'];
      return categories.map((item) => {
        'name': item['category'],
        'amount': item['totalAmount'],
        'type': item['category'] == 'Income' ? 'INCOME' : 'SPENDING'
      }).toList();
    } else {
      throw Exception('Failed to load top categories for account');
    }
  }

  // 更新交易分类
  Future<void> updateCategory(String transactionId, String newCategory) async {
    final userId = await _tokenService.getUserId();

    final response = await http.post(
      Uri.parse('$baseUrl/transactions/updateCategory'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'userId': userId,
        'id': transactionId,
        'category': newCategory
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update transaction category');
    }
  }
}