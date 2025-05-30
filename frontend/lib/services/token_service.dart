import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'userId';
  static const String _emailKey = 'email';
  static const String _basiqUserIdKey = 'basiqUserId';

  // 保存 token、userId、email 和 basiqUserId
  Future<void> saveToken(
    String token,
    String userId,
    String email,
    String basiqUserId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_basiqUserIdKey, basiqUserId);
  }

  // 获取 token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // 获取 userId
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // 获取 email
  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // 获取 basiqUserId
  Future<String?> getBasiqUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_basiqUserIdKey);
  }

  // 清除所有保存的凭证
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_basiqUserIdKey);
  }

  // 判断是否已登录
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
