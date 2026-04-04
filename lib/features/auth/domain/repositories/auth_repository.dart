import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'package:uuid/uuid.dart';

class AuthRepository {
  static const String _usersKey = 'users_list';
  static const String _currentUserKey = 'current_user';

  Future<void> register({
    required String email,
    required String phone,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing users
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    
    // Check if user already exists
    for (String userStr in usersJson) {
      final user = UserModel.fromJson(jsonDecode(userStr));
      if ((email.isNotEmpty && user.email == email) || 
          (phone.isNotEmpty && user.phone == phone)) {
        throw Exception('User already exists');
      }
    }

    // Create new user
    final newUser = UserModel(
      id: const Uuid().v4(),
      email: email,
      phone: phone,
      password: password,
      name: email.isNotEmpty ? email.split('@').first : phone,
    );

    usersJson.add(jsonEncode(newUser.toJson()));
    await prefs.setStringList(_usersKey, usersJson);
    
    // Automatically log in
    await prefs.setString(_currentUserKey, jsonEncode(newUser.toJson()));
  }

  Future<void> login({
    required String identifier, // Can be email or phone
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];
    
    for (String userStr in usersJson) {
      final user = UserModel.fromJson(jsonDecode(userStr));
      if ((user.email == identifier || user.phone == identifier) && user.password == password) {
        await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
        return;
      }
    }
    
    throw Exception('Invalid credentials');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_currentUserKey);
    if (userStr != null) {
      return UserModel.fromJson(jsonDecode(userStr));
    }
    return null;
  }
  
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
}
