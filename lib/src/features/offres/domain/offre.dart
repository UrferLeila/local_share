typedef OffreID = String;

class Offre {
  Offre({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.user,
  });

  final OffreID id;
  final String name;
  final String? description;
  final String? image;
  final OffreID user;

  factory Offre.fromJson(Map<String, dynamic> json) => Offre(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'],
    image: json['image'],
    user: json['user'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'description': description,
    'image': image,
    'user': user,
  };
}
