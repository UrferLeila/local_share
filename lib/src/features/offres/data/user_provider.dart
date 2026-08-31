import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_share/src/features/offres/domain/user.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null) {
    loadUser();
  }

  Future<void> setUser(Map<String, dynamic> userData) async {
    final user = User.fromJson(userData);
    state = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  // UPDATED: Now accepts optional profile photo bytes
  Future<void> setMicrosoftUser({
    required String id,
    required String username,
    required String email,
    String role = 'user',
    Uint8List? photo,
  }) async {
    final user = User(
      id: id,
      username: username,
      email: email,
      role: role,
      photo: photo,
    );
    state = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("user");
    if (userJson == null) return;
    final userData = jsonDecode(userJson);
    state = User.fromJson(Map<String, dynamic>.from(userData));
  }

  Future<void> logout() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("user");
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
