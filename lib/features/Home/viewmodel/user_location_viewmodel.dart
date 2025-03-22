import 'package:adrash/features/Home/model/user_geocoded_loc.dart';
import 'package:adrash/features/Home/repositories/user_location_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapControllerProvider = StateProvider<GoogleMapController?>((ref) {
  return null;
});

final isLocationPermissionEnabledProvider = StateProvider<bool>((ref) {
  return false;
});

final mapCameraPositionProvider = StateProvider<LatLng>((ref) {
  return LatLng(37.7749, -122.4194);
});

final userLocationCoordinatesProvider = StateProvider<Position?>((ref) {
  return null;
});

final userLocationGeocodedDataProvider = StateProvider<UserGeocodedLoc?>((ref) {
  return null;
});

final userLocationViewmodelProvider = StateNotifierProvider<UserLocationViewmodelNotifier, Position?>((ref) {
  final userLocationRepository = ref.watch(userLocationRepositoryProvider);
  final isLocationPermissionEnabledController = ref.watch(isLocationPermissionEnabledProvider.notifier);
  final userLocationCoordinatesController = ref.watch(userLocationCoordinatesProvider.notifier);
  final mapCameraPositionController = ref.watch(mapCameraPositionProvider.notifier);
  return UserLocationViewmodelNotifier(
    userLocationRepository: userLocationRepository,
    userLocationGeocodedDataController: ref.watch(userLocationGeocodedDataProvider.notifier),
    isLocationPermissionEnabledController: isLocationPermissionEnabledController,
    userLocationCoordinatesController: userLocationCoordinatesController,
    mapCameraPositionController: mapCameraPositionController,
  );
});

class UserLocationViewmodelNotifier extends StateNotifier<Position?> {
  UserLocationRepository userLocationRepository;
  StateController<UserGeocodedLoc?> userLocationGeocodedDataController;
  StateController<bool> isLocationPermissionEnabledController;
  StateController<Position?> userLocationCoordinatesController;
  StateController<LatLng> mapCameraPositionController;
  UserLocationViewmodelNotifier({
    required this.userLocationRepository,
    required this.userLocationGeocodedDataController,
    required this.isLocationPermissionEnabledController,
    required this.userLocationCoordinatesController,
    required this.mapCameraPositionController,
  }) : super(null);

  Future<bool> requestLocationPermission() async {
    await userLocationRepository.requestLocationPermission();
    bool isLocPermGranted = await _isLocationPermissionGranted();
    return isLocPermGranted;
  }

  Future<bool> _isLocationPermissionGranted() async {
    bool isLocationPermiGranted = await userLocationRepository.isLocationPermissionGranted();
    isLocationPermissionEnabledController.state = isLocationPermiGranted;
    return isLocationPermiGranted;
  }

  Future<Position> getUserLocation() async {
    Position position = await userLocationRepository.getUserLocation();
    userLocationCoordinatesController.state = position;
    LatLng newMapCameraPosition = LatLng(position.latitude, position.longitude);
    mapCameraPositionController.state = newMapCameraPosition;
    getGeocodingData(position);
    return position;
  }

  Future<UserGeocodedLoc?> getGeocodingData(Position position, {bool setState = true}) async {
    UserGeocodedLoc? placemark = await userLocationRepository.getGeocodingData(position);
    if (setState) {
      userLocationGeocodedDataController.state = placemark;
    }
    return placemark;
  }
}
