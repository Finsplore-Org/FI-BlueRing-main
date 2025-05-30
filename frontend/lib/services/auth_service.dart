import 'package:http/http.dart' as http;
import 'dart:convert';
import 'token_service.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080';
  final TokenService _tokenService = TokenService();

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        final userId = responseData['userId'];
        final email = responseData['email'];
        final basiqUserId = responseData['basiqUserId'];

        if (token == null || userId == null || email == null) {
          print(
            'Login response missing fields: token=$token, userId=$userId, email=$email',
          );
          return false;
        }

        await _tokenService.saveToken(
          token,
          userId.toString(),
          email.toString(),
          basiqUserId.toString(),
        );
        return true;
      } else {
        print('Login failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Login request failed: $e');
      return false;
    }
  }

  Future<bool> signup(
    String email,
    String firstName,
    String middleName,
    String lastName,
    String mobile,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'firstName': firstName,
          'middleName': middleName,
          'lastName': lastName,
          'mobile': mobile,
          'password': password,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Signup request failed: $e');
      return false;
    }
  }

  Future<bool> sendVerificationCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-verification-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Failed to send verification code: $e');
      return false;
    }
  }

  Future<bool> verifyCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'code': code}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Verification code validation failed: $e');
      return false;
    }
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'newPassword': newPassword}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Password reset failed: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _tokenService.clearToken();
  }

  Future<String?> getToken() async {
    return await _tokenService.getToken();
  }

  Future<String?> getUserId() async {
    return await _tokenService.getUserId();
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final token = await _tokenService.getToken();
      final email = await _tokenService.getEmail();

      if (token == null || email == null) {
        print('No token or email found');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/users/email/$email'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get user info: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Get user info request failed: $e');
      return null;
    }
  }

  Future<String?> getAuthLink() async {
    try {
      final token = await _tokenService.getToken();
      final userId = await _tokenService.getBasiqUserId();
    

      if (token == null || userId == null) {
        print('No token or userId found');
        return null;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/$userId/auth-link'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['authLink'];
      } else {
        print('Failed to get auth link: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Get auth link request failed: $e');
      return null;
    }
  }

  Future<bool> updatePhone(String phone) async {
    final email = await _tokenService.getEmail();
    final url = Uri.parse('$baseUrl/users/phone');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'mobile': phone}),
    );
    return response.statusCode == 200;
  }
}
