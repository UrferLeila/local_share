import 'proposition.dart';

typedef OffreID = String;

enum OfferType {
  achat,
  service,
  pret;

  static OfferType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'achat':
        return OfferType.achat;
      case 'service':
        return OfferType.service;
      case 'pret':
        return OfferType.pret;
      default:
        return OfferType.pret;
    }
  }

  String toShortString() {
    switch (this) {
      case OfferType.achat:
        return 'achat';
      case OfferType.service:
        return 'service';
      case OfferType.pret:
        return 'pret';
    }
  }
}

class Offre {
  final OffreID id;
  final String name;
  final String? description;
  final String? image;
  final OffreID user;
  final OfferType type;
  final List<Proposition> propositions;

  Offre({
    required this.id,
    required this.name,
    required this.user,
    required this.type,
    this.description,
    this.image,
    this.propositions = const [],
  });

  factory Offre.fromJson(Map<String, dynamic> json) => Offre(
    id: json['offerId']?.toString() ?? '',
    name: json['name'] ?? '',
    description: json['description'],
    image: json['image'],
    user: json['userId']?.toString() ?? '',
    type: parseOfferType(json["type"]),
    propositions: json['propositions'] != null
        ? (json['propositions'] as List)
              .map((p) => Proposition.fromJson(Map<String, dynamic>.from(p)))
              .toList()
        : [],
  );

  static OfferType parseOfferType(dynamic typeValue) {
    if (typeValue is int) {
      switch (typeValue) {
        case 0:
          return OfferType.pret;
        case 1:
          return OfferType.achat;
        case 2:
          return OfferType.service;
        default:
          return OfferType.pret;
      }
    }
    return OfferType.fromString(typeValue.toString());
  }

  Map<String, dynamic> toJson() => {
    'offerId': id,
    'name': name,
    'description': description,
    'image': image,
    'userId': user,
    'type': type.index,
    'propositions': propositions.map((p) => p.toJson()).toList(),
  };
}
