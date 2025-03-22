//map
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapCameraPositionProvider = StateProvider<LatLng>((ref) {
  return LatLng(9.0191936, 38.7524635);
});

final mapControllerProvider = StateProvider<GoogleMapController?>((ref) {
  return null;
});
