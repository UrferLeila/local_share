import 'suggestion.dart';

typedef OffreID = String;

enum OfferType {
  achat,
  service,
  pret;

  static OfferType fromString(String value) {
    switch (value.toLowerCase()) {
      case "achat":
        return OfferType.achat;
      case "service":
        return OfferType.service;
      case "pret":
        return OfferType.pret;
      default:
        return OfferType.pret;
    }
  }

  String toShortString() {
    switch (this) {
      case OfferType.achat:
        return "achat";
      case OfferType.service:
        return "service";
      case OfferType.pret:
        return "pret";
    }
  }
}

class Offer {
  final OffreID id;
  final String name;
  final String? description;
  final String? image;
  final String user;
  final OfferType type;
  final List<Suggestion> suggestions;

  Offer({
    required this.id,
    required this.name,
    required this.user,
    required this.type,
    this.description,
    this.image,
    this.suggestions = const [],
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    id: json["offerId"]?.toString() ?? '',
    name: json["name"] ?? '',
    description: json["description"],
    image: json["image"],
    user:
        json["azureId"]?.toString() ??
        json["AzureId"]?.toString() ??
        json["userId"]?.toString() ??
        "",
    type: parseOfferType(json["type"]),
    suggestions: json["suggestions"] != null
        ? (json["suggestions"] as List)
              .map((p) => Suggestion.fromJson(Map<String, dynamic>.from(p)))
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
    "offerId": id,
    "name": name,
    "description": description,
    "image": image,
    "azureId": user,
    "type": type.index,
    "suggestions": suggestions.map((p) => p.toJson()).toList(),
  };
}
