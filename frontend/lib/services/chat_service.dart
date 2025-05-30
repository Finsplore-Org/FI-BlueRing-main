import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_service.dart';

class ChatService {
  static const String baseUrl = 'http://localhost:8080';
  final TokenService _tokenService = TokenService();

  Future<String> sendMessage(String message) async {
    try {
      final userId = await _tokenService.getUserId();
      if (userId == null) {
        throw Exception('User ID not found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/chat/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': userId,
          'message': message,
        }),
      );
      if (response.statusCode == 200) {
        return response.body.toString();
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  Future<String> sendBillReminder(String message) async {
    try {
      final userId = await _tokenService.getUserId();
      if (userId == null) {
        throw Exception('User ID not found');
      }
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat/send/billReminder'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': userId,
          'message': message,
        }),
      );
      if (response.statusCode == 200) {
        return response.body.toString();
      } else {
        throw Exception('Failed to send bill reminder: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending bill reminder: $e');
    }
  }

  Future<Map<String, dynamic>> generateSuggestion(String message) async {
    try {
      final userId = await _tokenService.getUserId();
      if (userId == null) {
        throw Exception('User ID not found');
      }
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat/send/suggestion'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': userId,
          'message': message,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to generate suggestion: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating suggestion: $e');
    }
  }
}