import 'package:adrash/features/Home/viewmodel/map_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/user_location_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapWidget extends ConsumerStatefulWidget {
  const MapWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  @override
  void initState() {
    super.initState();
  }

  // Handle map creation
  void _onMapCreated(GoogleMapController controller, WidgetRef ref) async {
    ref.read(mapControllerProvider.notifier).state = controller;
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentPosition = ref.watch(mapCameraPositionProvider);
    bool isLocationServiceEnabled = ref.watch(isLocationServicesEnabledProvider);
    PermissionStatus permissionStatus = ref.watch(isLocationPermissionEnabledProvider);
    bool isLocationPermissionEnabled = permissionStatus == PermissionStatus.granted && isLocationServiceEnabled;
    Set<Polyline>? routePolyLine = ref.watch(routePolyLineProvider);
    Set<Marker>? mapMarkers = ref.watch(mapMarkerProvider);
    double mapZoomLevel = ref.watch(mapZoomLevelProvider);

    // logger.i(routePolyLine?.first.points);

    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) => _onMapCreated(controller, ref),
        initialCameraPosition: CameraPosition(
          target: currentPosition,
          // zoom: 17.4,
          zoom: mapZoomLevel,
        ),
        myLocationEnabled: isLocationPermissionEnabled, // Shows blue dot for current location
        myLocationButtonEnabled: false, // Enables "My Location" button
        polylines: routePolyLine ?? {},
        markers: mapMarkers ?? {},
      ),
    );
  }
}
