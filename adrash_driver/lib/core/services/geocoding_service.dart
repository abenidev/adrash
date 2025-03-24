import 'package:adrash_rider/core/models/user_geocoded_loc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

final geoCodingServiceProvider = StateProvider<GeocodingService>((ref) {
  return GeocodingService();
});

class GeocodingService {
  GeocodingService();

  Future<UserGeocodedLoc?> getGeocodedData(LocationData locationData) async {
    if (locationData.latitude == null || locationData.longitude == null) return null;
    List<Placemark> placemarks = await placemarkFromCoordinates(locationData.latitude!, locationData.longitude!);
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
