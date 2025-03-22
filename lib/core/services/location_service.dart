import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationServiceProvider = StateProvider<LocationService>((ref) {
  return LocationService();
});

class LocationService {
  LocationService();
}
