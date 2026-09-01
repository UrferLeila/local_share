class Proposition {
  final String id;
  final String userId;
  final String username;
  final String? userPhoto;
  final String description;
  final DateTime date;

  Proposition({
    required this.id,
    required this.userId,
    required this.username,
    this.userPhoto,
    required this.description,
    required this.date,
  });

  factory Proposition.fromJson(Map<String, dynamic> json) => Proposition(
    id: json['_id'] ?? json['id'] ?? '',
    userId: json['user']?.toString() ?? json['userId'] ?? '',
    username: json['username'] ?? 'Anonymous',
    userPhoto: json['userPhoto'],
    description: json['name'] ?? json['description'] ?? '',
    date: json['Date'] != null
        ? DateTime.parse(json['Date'])
        : (json['date'] != null
              ? DateTime.parse(json['date'])
              : DateTime.now()),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user': userId,
    'username': username,
    'userPhoto': userPhoto,
    'name': description,
    'Date': date.toIso8601String(),
  };
}
