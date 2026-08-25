import 'dart:convert';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;

final offerListNotifierProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  String url = "http://localhost:3000/offres";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == Sizes.p200) {
    final data = jsonDecode(response.body);

    return {
      "offres": (data['offres'] as List)
          .map((json) => Offre.fromJson(json))
          .toList(),
    };
  } else {
    throw Exception("Erreur ${response.statusCode}");
  }
});
