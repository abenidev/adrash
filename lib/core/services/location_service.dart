import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

final locationServiceProvider = StateProvider<LocationService>((ref) {
  return LocationService();
});

class LocationService {
  LocationService();
  Location location = Location();
  bool serviceEnabled = false;
  PermissionStatus permissionGranted = PermissionStatus.denied;

  Future<bool> changeSetting() async {
    return await location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0,
      interval: 10000,
    );
  }

  Future<bool> requestLocationService() async {
    await changeSetting();
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    return serviceEnabled;
  }

  Future<PermissionStatus> requestLocationPermission() async {
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    return permissionGranted;
  }

  Future<LocationData> getCurrentLocationData() async {
    LocationData locationData = await location.getLocation();
    return locationData;
  }

  Future<bool> enableBackgroundMode() async {
    return await location.enableBackgroundMode(enable: true);
  }

  Future<bool> disableBackgroundMode() async {
    return await location.enableBackgroundMode(enable: false);
  }

  Stream<LocationData> getLocationDataStream() {
    return location.onLocationChanged;
  }
}
