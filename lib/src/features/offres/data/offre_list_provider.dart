import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Provides compute and kIsWeb
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;

class OfferNotifier extends AsyncNotifier<Map<String, dynamic>> {
  Timer? _timer;

  @override
  Future<Map<String, dynamic>> build() async {
    _startPolling();
    return _fetchData();
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      try {
        final newData = await _fetchData();
        state = AsyncValue.data(newData);
      } catch (_) {
      }
    });

    ref.onDispose(() {
      _timer?.cancel();
    });
  }

  Future<Map<String, dynamic>> _fetchData() async {
    String baseUrl = kIsWeb
        ? "http://localhost:3000"
        : "http://157.26.120.161:3000";
    String url = "$baseUrl/offres";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == Sizes.p200) {
      return compute(_parseOfferResponse, response.body);
    } else {
      throw Exception("Erreur ${response.statusCode}");
    }
  }
}

Map<String, dynamic> _parseOfferResponse(String responseBody) {
  final data = jsonDecode(responseBody);
  return {
    "offres": (data['offres'] as List)
        .map((json) => Offre.fromJson(json))
        .toList(),
  };
}

final offerListNotifierProvider =
    AsyncNotifierProvider<OfferNotifier, Map<String, dynamic>>(
      OfferNotifier.new,
    );
