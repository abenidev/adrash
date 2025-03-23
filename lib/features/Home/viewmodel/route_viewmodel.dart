import 'package:adrash/core/services/route_service.dart';
import 'package:adrash/features/Home/viewmodel/map_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/user_location_viewmodel.dart';
import 'package:adrash/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_location_search/flutter_location_search.dart' as fls;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

final destinationLocationDataProvider = StateProvider<fls.LocationData?>((ref) {
  return null;
});

final routeViewmodelProvider = StateNotifierProvider<RouteViewmodelNotifier, void>((ref) {
  final routeService = ref.watch(routeServiceProvider);
  final destinationLocationDataController = ref.watch(destinationLocationDataProvider.notifier);
  final currentLocationData = ref.watch(currentLocationProvider);
  final routePolyLineController = ref.watch(routePolyLineProvider.notifier);
  final mapMarkerController = ref.watch(mapMarkerProvider.notifier);
  final mapZoomLevelController = ref.watch(mapZoomLevelProvider.notifier);
  return RouteViewmodelNotifier(
    routeService: routeService,
    destinationLocationDataController: destinationLocationDataController,
    currentLocationData: currentLocationData,
    routePolyLineController: routePolyLineController,
    mapMarkerController: mapMarkerController,
    mapZoomLevelController: mapZoomLevelController,
  );
});

class RouteViewmodelNotifier extends StateNotifier<void> {
  RouteService routeService;
  StateController<fls.LocationData?> destinationLocationDataController;
  LocationData? currentLocationData;
  StateController<Set<Polyline>?> routePolyLineController;
  StateController<Set<Marker>?> mapMarkerController;
  StateController<double> mapZoomLevelController;
  RouteViewmodelNotifier({
    required this.routeService,
    required this.destinationLocationDataController,
    required this.currentLocationData,
    required this.routePolyLineController,
    required this.mapMarkerController,
    required this.mapZoomLevelController,
  }) : super(null);

  Future<void> getRouteData(fls.LocationData? destinationLocData) async {
    destinationLocationDataController.state = destinationLocData;
    if (destinationLocData == null || currentLocationData == null) return;
    if (currentLocationData!.latitude == null || currentLocationData!.longitude == null) return;
    LatLng startLoc = LatLng(currentLocationData!.latitude!, currentLocationData!.longitude!);
    LatLng endLoc = LatLng(destinationLocData.latitude, destinationLocData.longitude);
    try {
      Map<String, dynamic> response = await routeService.getDirections(startLoc: startLoc, endLoc: endLoc);
      // logger.i("polyPoints: ${response['features'][0]['geometry']['coordinates']}");
      if (response['features'] == null) throw Exception('Failed to fetch directions, Please try again!');
      if ((response['features'] as List).isEmpty) throw Exception('Failed to fetch directions, Please try again!');
      if (response['features'][0]['geometry'] == null) throw Exception('Failed to fetch directions, Please try again!');
      if (response['features'][0]['geometry']['coordinates'] == null) throw Exception('Failed to fetch directions, Please try again!');

      List<LatLng> polyPoints = [];
      final routeCoords = response['features'][0]['geometry']['coordinates'] as List;
      for (int i = 0; i < routeCoords.length; i++) {
        if (routeCoords[i][0] != null && routeCoords[i][1] != null) {
          polyPoints.add(LatLng(routeCoords[i][1], routeCoords[i][0]));
        }
      }

      Polyline polyline = Polyline(polylineId: PolylineId('route'), points: polyPoints, color: Colors.black, width: 5);
      routePolyLineController.state = {polyline};

      Marker destinationMarker = Marker(markerId: MarkerId('destination'), position: endLoc, icon: BitmapDescriptor.defaultMarker);
      mapMarkerController.state = {destinationMarker};
      mapZoomLevelController.state = 17.4;
    } catch (e) {
      logger.e(e);
      rethrow;
    }

    //
  }

  //!
  // Future<void> getRouteData(fls.LocationData? destinationLocData) async {
  //   destinationLocationDataController.state = destinationLocData;
  //   if (destinationLocData == null || currentLocationData == null) return;
  //   if (currentLocationData!.latitude == null || currentLocationData!.longitude == null) return;
  //   LatLng startLoc = LatLng(currentLocationData!.latitude!, currentLocationData!.longitude!);
  //   LatLng endLoc = LatLng(destinationLocData.latitude, destinationLocData.longitude);
  //   try {
  //     List<LatLng> polyPoints = await routeService.getRouteCoordinates(startLoc, endLoc);

  //     Polyline polyline = Polyline(polylineId: PolylineId('route'), points: polyPoints, color: Colors.black, width: 5);
  //     routePolyLineController.state = {polyline};

  //     Marker destinationMarker = Marker(markerId: MarkerId('destination'), position: endLoc, icon: BitmapDescriptor.defaultMarker);
  //     mapMarkerController.state = {destinationMarker};
  //   } catch (e) {
  //     logger.e(e);
  //     rethrow;
  //   }

  //   //
  // }
}
