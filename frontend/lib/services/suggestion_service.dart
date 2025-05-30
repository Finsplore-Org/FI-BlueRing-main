import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class SuggestionService {
  static const String baseUrl = 'http://localhost:8080';
  final TokenService _tokenService = TokenService();

  Future<Map<String, dynamic>> createSuggestion(String suggestionText, double expectedSaveAmount) async {
    final userId = await _tokenService.getUserId();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/suggestions/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'suggestionText': suggestionText,
          'expectedSaveAmount': expectedSaveAmount
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create suggestion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating suggestion: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSuggestions() async {
    final userId = await _tokenService.getUserId();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/suggestions/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to get suggestions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching suggestions: $e');
    }
  }

  Future<void> deleteSuggestion(int suggestionId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/suggestions/$suggestionId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete suggestion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting suggestion: $e');
    }
  }
}