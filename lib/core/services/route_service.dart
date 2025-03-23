import 'dart:convert';

import 'package:adrash/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

final routeServiceProvider = StateProvider<RouteService>((ref) {
  return RouteService();
});

class RouteService {
  RouteService();

  Future<Map<String, dynamic>> getDirections({
    required LatLng startLoc,
    required LatLng endLoc,
  }) async {
    final String url =
        "https://api.openrouteservice.org/v2/directions/driving-car?api_key=${Env.apiKey}&start=${startLoc.longitude},${startLoc.latitude}&end=${endLoc.longitude},${endLoc.latitude}";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch directions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching directions: $e');
    }
  }
}
