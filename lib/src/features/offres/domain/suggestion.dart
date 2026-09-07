typedef SuggestionID = String;

class Suggestion {
  final SuggestionID id;
  final String userId;
  final String username;
  final String? userPhoto;
  final String description;
  final DateTime date;

  Suggestion({
    required this.id,
    required this.userId,
    required this.username,
    this.userPhoto,
    required this.description,
    required this.date,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
    id: (json["suggestionId"] ?? json["id"] ?? "").toString(),
    userId: json["userId"]?.toString() ?? json["user"]?.toString() ?? "",
    username: json["username"] ?? "Anonymous",
    userPhoto: json["userPhoto"] is String ? json["userPhoto"] : null,
    description: json["name"] ?? json["description"] ?? '',
    date: json["Date"] != null
        ? DateTime.parse(json["Date"])
        : (json["date"] != null
              ? DateTime.parse(json["date"])
              : DateTime.now()),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": userId,
    "username": username,
    "userPhoto": userPhoto,
    "name": description,
    "Date": date.toIso8601String(),
  };
}
