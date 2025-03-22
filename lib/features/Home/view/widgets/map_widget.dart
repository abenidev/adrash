import 'package:adrash/features/Home/viewmodel/user_location_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class MapWidget extends ConsumerStatefulWidget {
  const MapWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  // late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {});
  }

  // Handle map creation
  void _onMapCreated(GoogleMapController controller, WidgetRef ref) async {
    ref.read(mapControllerProvider.notifier).state = controller;
    // bool isLocPermGranted = await ref.read(userLocationViewmodelProvider.notifier).requestLocationPermission();
    // while (!isLocPermGranted) {
    // if (mounted) showEnableLocPermissionDialog(context);
    // isLocPermGranted = await ref.read(userLocationViewmodelProvider.notifier).requestLocationPermission();
    // }
    // Position? position = await ref.read(userLocationViewmodelProvider.notifier).getUserLocation();
    // controller.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentPosition = ref.watch(mapCameraPositionProvider);

    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) => _onMapCreated(controller, ref),
        initialCameraPosition: CameraPosition(
          target: currentPosition,
          zoom: 16.0,
        ),
        myLocationEnabled: true, // Shows blue dot for current location
        myLocationButtonEnabled: false, // Enables "My Location" button
      ),
    );
  }
}
