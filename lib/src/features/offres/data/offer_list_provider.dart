import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/domain/offer.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;

class OfferNotifier extends AsyncNotifier<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> build() async {
    return _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    String baseUrl = kIsWeb
        ? "https://localhost:7024"
        : "https://10.0.2.2:7024";
    String url = "$baseUrl/api/offer";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == Sizes.p200) {
      return compute(parseOfferResponse, response.body);
    } else {
      throw Exception("Erreur ${response.statusCode}");
    }
  }
}

Map<String, dynamic> parseOfferResponse(String responseBody) {
  final List<dynamic> jsonList = jsonDecode(responseBody);
  return {
    "offres": jsonList
        .map((json) => Offre.fromJson(Map<String, dynamic>.from(json)))
        .toList(),
  };
}

final offerListNotifierProvider =
    AsyncNotifierProvider<OfferNotifier, Map<String, dynamic>>(
      OfferNotifier.new,
    );
