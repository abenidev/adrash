//map
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapCameraPositionProvider = StateProvider<LatLng>((ref) {
  return LatLng(9.0191936, 38.7524635);
});

final mapControllerProvider = StateProvider<GoogleMapController?>((ref) {
  return null;
});

final routePolyLineProvider = StateProvider<Set<Polyline>?>((ref) {
  return null;
});

final mapMarkerProvider = StateProvider<Set<Marker>?>((ref) {
  return null;
});

final mapZoomLevelProvider = StateProvider<double>((ref) {
  return 17.4;
});
