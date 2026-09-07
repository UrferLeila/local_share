import 'dart:convert';
import 'dart:typed_data';

class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.photo,
  });

  final String id;
  final String username;
  final String email;
  final String role;
  final Uint8List? photo;

  factory User.fromJson(Map<String, dynamic> json) {
    Uint8List? decodedPhoto;
    if (json['photo'] != null) {
      try {
        if (json['photo'] is String) {
          decodedPhoto = base64Decode(json['photo']);
        }
      } catch (_) {
        decodedPhoto = null;
      }
    }
    final resolvedId = json['azureId'] ?? json['AzureId'] ?? '';

    return User(
      id: resolvedId.isNotEmpty
          ? resolvedId
          : (json['id']?.toString().contains('@') == false
                ? json['id'] ?? ''
                : ''),
      username: json['userName'] ?? json['UserName'] ?? json['username'] ?? '',
      email: json['email'] ?? json['Email'] ?? '',
      role: json['role'] ?? json['Role'] ?? 'user',
      photo: decodedPhoto,
    );
  }

  bool get isAdmin => role == 'admin';

  Map<String, dynamic> toJson() {
    return {
      'azureId': id,
      'userName': username,
      'email': email,
      'role': role,
      'photo': photo != null ? base64Encode(photo!) : null,
    };
  }
}
