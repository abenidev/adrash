import 'package:adrash/core/services/firestore_service.dart';
import 'package:adrash/core/services/geocoding_service.dart';
import 'package:adrash/core/services/location_service.dart';
import 'package:adrash/features/Home/model/user_geocoded_loc.dart';
import 'package:adrash/features/Home/viewmodel/map_viewmodel.dart';
import 'package:adrash/features/auth/model/user_data.dart';
import 'package:adrash/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:adrash/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// Location Stream Provider (AutoDispose to save resources)
final locationStreamProvider = StreamProvider.autoDispose<LocationData>((ref) async* {
  final locationService = ref.read(locationServiceProvider);
  yield* locationService.getLocationDataStream();
});
final shouldReAnimateMapPositionProvider = StateProvider<bool>((ref) {
  return true;
});
// State Provider to hold the latest location
final currentLocationProvider = StateProvider<LocationData?>((ref) => null);
final locationUpdaterProvider = Provider<void>((ref) {
  ref.listen(locationStreamProvider, (previous, next) {
    if (next.hasValue) {
      ref.read(currentLocationProvider.notifier).state = next.value;
      if (next.value == null) return;
      if (next.value?.latitude == null || next.value?.longitude == null) return;

      bool shouldReanimateMapPosition = ref.read(shouldReAnimateMapPositionProvider);
      LatLng newLatLng = LatLng(next.value!.latitude!, next.value!.longitude!);
      ref.read(mapCameraPositionProvider.notifier).state = newLatLng;
      if (ref.read(mapControllerProvider.notifier).state == null) return;
      logger.i("New Location: $newLatLng");

      //update user coll last loc data on firestore
      UserData? currentUserData = ref.read(authViewmodelProvider);
      if (currentUserData != null) {
        ref.read(firestoreServiceProvider).updateUserCollLocation(currentUserData.docDataId, newLatLng);
      }

      if (shouldReanimateMapPosition) {
        ref.read(mapControllerProvider.notifier).state!.animateCamera(CameraUpdate.newLatLng(newLatLng));
        ref.read(shouldReAnimateMapPositionProvider.notifier).state = false;
      }
    }
  });
});

//location
final isLocationPermissionEnabledProvider = StateProvider<PermissionStatus>((ref) {
  return PermissionStatus.denied;
});

final isLocationServicesEnabledProvider = StateProvider<bool>((ref) {
  return false;
});

final userLocationGeocodedDataProvider = StateProvider<UserGeocodedLoc?>((ref) {
  return null;
});

final userLocationViewmodelProvider = StateNotifierProvider<UserLocationViewmodelNotifier, void>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  final geoCodingService = ref.watch(geoCodingServiceProvider);
  final isLocationPermissionEnabledController = ref.watch(isLocationPermissionEnabledProvider.notifier);
  final isLocationServicesEnabledController = ref.watch(isLocationServicesEnabledProvider.notifier);
  final userLocationGeocodedDataController = ref.watch(userLocationGeocodedDataProvider.notifier);
  return UserLocationViewmodelNotifier(
    locationService: locationService,
    geocodingService: geoCodingService,
    isLocationPermissionEnabledController: isLocationPermissionEnabledController,
    isLocationServicesEnabledController: isLocationServicesEnabledController,
    userLocationGeocodedDataController: userLocationGeocodedDataController,
  );
});

class UserLocationViewmodelNotifier extends StateNotifier<void> {
  LocationService locationService;
  GeocodingService geocodingService;
  StateController<PermissionStatus> isLocationPermissionEnabledController;
  StateController<bool> isLocationServicesEnabledController;
  StateController<UserGeocodedLoc?> userLocationGeocodedDataController;
  UserLocationViewmodelNotifier({
    required this.locationService,
    required this.geocodingService,
    required this.isLocationPermissionEnabledController,
    required this.isLocationServicesEnabledController,
    required this.userLocationGeocodedDataController,
  }) : super(null);

  Future<bool> requestLocationService() async {
    bool serviceEnabled = await locationService.requestLocationService();
    isLocationServicesEnabledController.state = serviceEnabled;
    return serviceEnabled;
  }

  Future<PermissionStatus> requestLocationPermission() async {
    PermissionStatus permissionStatus = await locationService.requestLocationPermission();
    isLocationPermissionEnabledController.state = permissionStatus;
    return permissionStatus;
  }

  Future<LocationData> getCurrentLocationData() async {
    LocationData locationData = await locationService.getCurrentLocationData();
    getGeocodedData(locationData);
    return locationData;
  }

  Future<UserGeocodedLoc?> getGeocodedData(LocationData locationData, {bool setState = true}) async {
    UserGeocodedLoc? userGeocodedLoc = await geocodingService.getGeocodedData(locationData);
    if (setState) {
      userLocationGeocodedDataController.state = userGeocodedLoc;
    }
    return userGeocodedLoc;
  }
}
