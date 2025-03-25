//map
import 'package:adrash_rider/core/constants/app_consts.dart';
import 'package:adrash_rider/core/constants/app_nums.dart';
import 'package:adrash_rider/features/home/model/route_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapCameraPositionProvider = StateProvider<LatLng>((ref) {
  return defaultMapCoordinate;
});

final mapControllerProvider = StateProvider<GoogleMapController?>((ref) {
  return null;
});

final routeDataProvider = StateProvider<RouteData?>((ref) {
  return null;
});

final mapZoomLevelProvider = StateProvider<double>((ref) {
  return defaultMapZoomLevel;
});
