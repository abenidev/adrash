import 'package:adrash/core/constants/app_strings.dart';
import 'package:adrash/core/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final firestoreServiceProvider = StateProvider<FirestoreService>((ref) {
  return FirestoreService();
});

class FirestoreService {
  FirestoreService();
  final _firestore = FirebaseFirestore.instance;

  Future<void> updateUserCollLocation(String docId, LatLng newLocation) async {
    try {
      await _firestore.collection(usersCollectionName).doc(docId).update({
        'lastLocData': convertLatLongToGeoPoint(newLocation),
      });
    } catch (e) {
      rethrow;
    }
  }
}
