import 'package:adrash/core/constants/app_consts.dart';
import 'package:adrash/core/constants/app_nums.dart';
import 'package:adrash/core/constants/app_strings.dart';
import 'package:adrash/features/Home/model/route_data.dart';
import 'package:adrash/features/Home/model/vehicle_type.dart';
import 'package:adrash/features/Home/viewmodel/map_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/route_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_location_search/flutter_location_search.dart' as fls;

final selectedVehicleTypeProvider = StateProvider<VehicleType?>((ref) {
  return null;
});

final rideViewmodelProvider = StateNotifierProvider<RideViewmodelNotifier, void>((ref) {
  final routeDataController = ref.watch(routeDataProvider.notifier);
  final mapZoomLevelController = ref.watch(mapZoomLevelProvider.notifier);
  final mapCameraPositionController = ref.watch(mapCameraPositionProvider.notifier);
  final mapController = ref.watch(mapControllerProvider.notifier);
  final destinationLocationDataController = ref.watch(destinationLocationDataProvider.notifier);
  final selectedVehicleTypeController = ref.watch(selectedVehicleTypeProvider.notifier);
  final mapMarkerController = ref.watch(mapMarkerProvider.notifier);
  return RideViewmodelNotifier(
    routeDataController: routeDataController,
    mapZoomLevelController: mapZoomLevelController,
    mapCameraPositionController: mapCameraPositionController,
    mapController: mapController,
    destinationLocationDataController: destinationLocationDataController,
    selectedVehicleTypeController: selectedVehicleTypeController,
    mapMarkerController: mapMarkerController,
  );
});

class RideViewmodelNotifier extends StateNotifier<void> {
  StateController<RouteData?> routeDataController;
  StateController<double> mapZoomLevelController;
  StateController<LatLng> mapCameraPositionController;
  StateController<GoogleMapController?> mapController;
  StateController<fls.LocationData?> destinationLocationDataController;
  StateController<VehicleType?> selectedVehicleTypeController;
  StateController<Set<Marker>> mapMarkerController;

  RideViewmodelNotifier({
    required this.routeDataController,
    required this.mapZoomLevelController,
    required this.mapCameraPositionController,
    required this.mapController,
    required this.destinationLocationDataController,
    required this.selectedVehicleTypeController,
    required this.mapMarkerController,
  }) : super(null);

  void cancelRide() {
    RouteData? oldRouteData = routeDataController.state;
    if (oldRouteData != null) {
      //reset map to current user location
      mapController.state!.animateCamera(CameraUpdate.newLatLng(oldRouteData.startLoc));
    }
    routeDataController.state = null;
    mapZoomLevelController.state = defaultMapZoomLevel;
    mapCameraPositionController.state = defaultMapCoordinate;
    destinationLocationDataController.state = null;
    selectedVehicleTypeController.state = null;

    //remove marker
    Set<Marker> oldMarkers = mapMarkerController.state;
    oldMarkers.removeWhere((marker) => marker.markerId.value == destinationMarkerId);
    mapMarkerController.state = oldMarkers;
  }
}
