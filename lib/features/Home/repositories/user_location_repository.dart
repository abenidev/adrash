import 'dart:io';

import 'package:adrash/features/Home/model/user_geocoded_loc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

final userLocationRepositoryProvider = StateProvider<UserLocationRepository>((ref) {
  return UserLocationRepository();
});

class UserLocationRepository {
  UserLocationRepository();

  Future<PermissionStatus> requestLocationPermission() async {
    return await Permission.location.request();
  }

  Future<bool> isLocationPermissionGranted() async {
    return await Permission.location.isGranted;
  }

  Future<Position> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: Platform.isAndroid ? AndroidSettings(accuracy: LocationAccuracy.high) : AppleSettings(accuracy: LocationAccuracy.high),
    );
    return position;
  }

  Future<UserGeocodedLoc?> getGeocodingData(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    String locationName = placemarks[0].name ?? ''; // <street name>
    String subLocality = placemarks[0].subLocality ?? ''; // Kolfe Keranio
    String locality = placemarks[0].locality ?? ''; // Addis Ababa
    if (placemarks.isNotEmpty) {
      UserGeocodedLoc userGeocodedLoc = UserGeocodedLoc(name: locationName, subLocality: subLocality, locality: locality);
      return userGeocodedLoc;
    }
    return null;
  }
}
