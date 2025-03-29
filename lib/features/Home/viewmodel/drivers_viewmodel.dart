import 'package:adrash/core/constants/app_strings.dart';
import 'package:adrash/core/models/driver_data.dart';
import 'package:adrash/features/Home/viewmodel/map_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/user_location_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final driversDataRangedStreamProvider = StreamProvider<List<DriverData>>((ref) {
  // UserData? userData = ref.watch(authViewmodelProvider);
  final currentUserLocation = ref.watch(currentLocationProvider);
  if (currentUserLocation == null) throw Exception('User is not signed in');
  if (currentUserLocation.latitude == null) throw Exception('User Location Unknown');
  if (currentUserLocation.longitude == null) throw Exception('User Location Unknown');
  GeoPoint currentUserGeoPoint = GeoPoint(currentUserLocation.latitude!, currentUserLocation.longitude!);
  GeoFirePoint center = GeoFirePoint(currentUserGeoPoint);

  //
  final CollectionReference<Map<String, dynamic>> driversCollRef = FirebaseFirestore.instance.collection(driversCollectionName);

  GeoPoint geopointFrom(Map<String, dynamic> data) => (data['lastLocData'] as Map<String, dynamic>)['geopoint'] as GeoPoint;
  Query<Map<String, dynamic>> queryBuilder(Query<Map<String, dynamic>> query) => query.where('isDriverAvailable', isEqualTo: true);

  return GeoCollectionReference<Map<String, dynamic>>(driversCollRef)
      .subscribeWithin(
        center: center,
        radiusInKm: 1,
        field: 'lastLocData',
        geopointFrom: geopointFrom,
        queryBuilder: queryBuilder,
      )
      .map((data) => data.map((e) => DriverData.fromMap(e.data() as Map<String, dynamic>)).toList());
});

final driversRangedListDataProvider = StateProvider<List<DriverData>>((ref) {
  return [];
});

final driversDataRangedUpdaterProvider = Provider<void>((ref) {
  ref.listen(driversDataRangedStreamProvider, (previous, next) async {
    if (next.hasValue) {
      ref.read(driversRangedListDataProvider.notifier).state = next.value ?? [];
      if (next.value == null) return;

      //modify drivers marker to map
      BitmapDescriptor driverIcon = await BitmapDescriptor.asset(
        ImageConfiguration(size: Size(35, 35)), // Adjust size
        'assets/icon/driver_icon.png',
      );

      //add and remove drivers markers
      Set<Marker> oldMarkerData = ref.read(mapMarkerProvider);
      List<Marker> destinationMarker = oldMarkerData.where((marker) => marker.markerId.value == destinationMarkerId).toList();
      Set<Marker> updatedMarker = {};
      if (destinationMarker.isNotEmpty) updatedMarker.add(destinationMarker.first);
      for (DriverData driverData in next.value!) {
        Marker newDriverMarker = Marker(markerId: MarkerId(driverData.driverDocId), position: LatLng(driverData.lastLocLat, driverData.lastLocLong), icon: driverIcon);
        updatedMarker.add(newDriverMarker);
      }
      ref.read(mapMarkerProvider.notifier).state = updatedMarker;
    }
  });
});

final driversViewmodelProvider = StateNotifierProvider<DriversViewmodelNotifier, List<DriverData>>((ref) {
  return DriversViewmodelNotifier();
});

class DriversViewmodelNotifier extends StateNotifier<List<DriverData>> {
  DriversViewmodelNotifier() : super([]);
}
