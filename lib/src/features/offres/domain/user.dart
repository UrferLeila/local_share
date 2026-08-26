class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  final String id;
  final String username;
  final String email;
  final String role;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  bool get isAdmin => role == 'admin';

  Map<String, dynamic> toJson() {
    return {'id': id, 'username': username, 'email': email, 'role': role};
  }
}
