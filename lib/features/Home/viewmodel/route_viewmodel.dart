import 'package:adrash/core/services/route_service.dart';
import 'package:adrash/features/Home/model/route_data.dart';
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
  final mapZoomLevelController = ref.watch(mapZoomLevelProvider.notifier);
  final routeDataController = ref.watch(routeDataProvider.notifier);
  final mapController = ref.watch(mapControllerProvider.notifier);
  return RouteViewmodelNotifier(
    routeService: routeService,
    destinationLocationDataController: destinationLocationDataController,
    currentLocationData: currentLocationData,
    mapZoomLevelController: mapZoomLevelController,
    routeDataController: routeDataController,
    mapController: mapController,
  );
});

class RouteViewmodelNotifier extends StateNotifier<void> {
  RouteService routeService;
  StateController<fls.LocationData?> destinationLocationDataController;
  LocationData? currentLocationData;
  StateController<double> mapZoomLevelController;
  StateController<RouteData?> routeDataController;
  StateController<GoogleMapController?> mapController;
  RouteViewmodelNotifier({
    required this.routeService,
    required this.destinationLocationDataController,
    required this.currentLocationData,
    required this.mapZoomLevelController,
    required this.routeDataController,
    required this.mapController,
  }) : super(null);

  Future<void> getRouteData(fls.LocationData? destinationLocData) async {
    if (destinationLocData == null || currentLocationData == null) return;
    if (currentLocationData!.latitude == null || currentLocationData!.longitude == null) return;
    LatLng startLoc = LatLng(currentLocationData!.latitude!, currentLocationData!.longitude!);
    LatLng endLoc = LatLng(destinationLocData.latitude, destinationLocData.longitude);
    try {
      Map<String, dynamic> response = await routeService.getDirections(startLoc: startLoc, endLoc: endLoc);
      // logger.i("polyPoints: ${response['features'][0]['geometry']['coordinates']}");
      if (response['features'] == null) throw Exception('Failed to fetch directions: features, Please try again!');
      if ((response['features'] as List).isEmpty) throw Exception('Failed to fetch directions: features is empty, Please try again!');
      if (response['features'][0]['geometry'] == null) throw Exception('Failed to fetch directions: geometry, Please try again!');
      if (response['features'][0]['geometry']['coordinates'] == null) throw Exception('Failed to fetch directions: coordinates, Please try again!');
      if (response['features'][0]['properties'] == null) throw Exception('Failed to fetch directions: properties, Please try again!');
      if (response['features'][0]['properties']['summary'] == null) throw Exception('Failed to fetch directions: summary, Please try again!');
      if (response['features'][0]['properties']['summary']['distance'] == null) throw Exception('Failed to fetch directions: distance, Please try again!');
      if (response['features'][0]['properties']['summary']['duration'] == null) throw Exception('Failed to fetch directions: duration, Please try again!');

      //summary
      double distance = response['features'][0]['properties']['summary']['distance'];
      double durationInSecondDouble = response['features'][0]['properties']['summary']['duration'];
      Duration duration = Duration(seconds: durationInSecondDouble.toInt());

      List<LatLng> polyPoints = [];
      final routeCoords = response['features'][0]['geometry']['coordinates'] as List;
      for (int i = 0; i < routeCoords.length; i++) {
        if (routeCoords[i][0] != null && routeCoords[i][1] != null) {
          polyPoints.add(LatLng(routeCoords[i][1], routeCoords[i][0]));
        }
      }

      Polyline polyline = Polyline(polylineId: PolylineId('route'), points: polyPoints, color: Colors.black, width: 5);
      Marker startMarker = Marker(markerId: MarkerId('start'), position: startLoc, icon: BitmapDescriptor.defaultMarker);
      Marker destinationMarker = Marker(markerId: MarkerId('destination'), position: endLoc, icon: BitmapDescriptor.defaultMarker);
      RouteData newRouteData = RouteData(
        startLoc: startLoc,
        endLoc: endLoc,
        polyline: {polyline},
        startMarker: startMarker,
        destinationMarker: destinationMarker,
        distanceInMeters: distance,
        durationInSeconds: duration,
      );
      destinationLocationDataController.state = destinationLocData;
      routeDataController.state = newRouteData;
      // mapZoomLevelController.state = defaultMapZoomLevel;

      //
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          startLoc.latitude < endLoc.latitude ? startLoc.latitude : endLoc.latitude,
          startLoc.longitude < endLoc.longitude ? startLoc.longitude : endLoc.longitude,
        ),
        northeast: LatLng(
          startLoc.latitude > endLoc.latitude ? startLoc.latitude : endLoc.latitude,
          startLoc.longitude > endLoc.longitude ? startLoc.longitude : endLoc.longitude,
        ),
      );

      if (mapController.state != null) {
        mapController.state!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 120));
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
