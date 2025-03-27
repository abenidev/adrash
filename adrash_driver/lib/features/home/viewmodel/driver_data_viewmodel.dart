import 'package:adrash_rider/core/constants/app_strings.dart';
import 'package:adrash_rider/core/models/driver_data.dart';
import 'package:adrash_rider/core/services/firestore_service.dart';
import 'package:adrash_rider/features/auth/model/user_data.dart';
import 'package:adrash_rider/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final driverDataStreamProvider = StreamProvider<DriverData>((ref) {
  UserData? userData = ref.watch(authViewmodelProvider);
  return FirebaseFirestore.instance
      .collection(driversCollectionName)
      .doc(userData!.driverDataDocId)
      .snapshots()
      .map((snapshot) => DriverData.fromMap(snapshot.data() as Map<String, dynamic>));
});

final driverDataViewmodelProvider = StateNotifierProvider<DriverDataViewmodelNotifier, DriverData?>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final authViewmodelNotifier = ref.watch(authViewmodelProvider.notifier);
  return DriverDataViewmodelNotifier(
    firestoreService: firestoreService,
    authViewmodelNotifier: authViewmodelNotifier,
  );
});

class DriverDataViewmodelNotifier extends StateNotifier<DriverData?> {
  FirestoreService firestoreService;
  AuthViewmodelNotifier authViewmodelNotifier;

  DriverDataViewmodelNotifier({
    required this.firestoreService,
    required this.authViewmodelNotifier,
  }) : super(null);

  Future<void> updateDriverAvailability(bool isDriverAvailable) async {
    UserData? userData = authViewmodelNotifier.state;
    if (userData == null) throw Exception('User is not signed in');
    try {
      await firestoreService.updateDriverAvailability(userData.driverDataDocId, isDriverAvailable);
    } catch (e) {
      rethrow;
    }
  }
}
