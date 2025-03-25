import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

String getUuid() {
  Uuid uuid = const Uuid();
  return uuid.v4();
}

Map<String, dynamic> convertLatLongToGeoPoint(LatLng latLng) {
  // Define GeoFirePoint by instantiating GeoFirePoint with latitude and longitude.
  final GeoFirePoint geoFirePoint = GeoFirePoint(GeoPoint(latLng.latitude, latLng.longitude));
  // Gets GeoPoint instance and Geohash string as Map<String, dynamic>.
  // {geopoint: Instance of 'GeoPoint', geohash: xn76urx66}
  final Map<String, dynamic> data = geoFirePoint.data;
  return data;
}
