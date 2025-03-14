import 'dart:io';

import 'package:adrash/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapWidget extends ConsumerStatefulWidget {
  const MapWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(37.7749, -122.4194); // Default location (San Francisco)

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // Request location permission
  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getUserLocation();
    } else {
      logger.i("Location permission denied");
    }
  }

  // Get user's current location
  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: Platform.isAndroid ? AndroidSettings(accuracy: LocationAccuracy.high) : AppleSettings(accuracy: LocationAccuracy.high),
    );
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    logger.i('lat: ${position.latitude} | long: ${position.longitude}');
    _mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
  }

  // Handle map creation
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _getUserLocation(); // Fetch location once map is ready
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 16.0,
        ),
        myLocationEnabled: true, // Shows blue dot for current location
        myLocationButtonEnabled: true, // Enables "My Location" button
      ),
    );
  }
}
