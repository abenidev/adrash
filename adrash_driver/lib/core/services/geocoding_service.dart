import 'package:adrash_rider/core/models/user_geocoded_loc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final geoCodingServiceProvider = StateProvider<GeocodingService>((ref) {
  return GeocodingService();
});

class GeocodingService {
  GeocodingService();

  Future<UserGeocodedLoc?> getGeocodedData(LatLng locationData) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude, locationData.longitude);
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
