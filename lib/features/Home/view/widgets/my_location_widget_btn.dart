import 'package:adrash/features/Home/viewmodel/map_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/user_location_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyLocationWidgetBtn extends ConsumerWidget {
  const MyLocationWidgetBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GoogleMapController? mapController = ref.watch(mapControllerProvider);

    if (mapController == null) {
      return SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [BoxShadow(color: Colors.grey.shade400, offset: Offset(2, 4), blurRadius: 10)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            LocationData? locationData = ref.read(currentLocationProvider);
            if (locationData == null) return;
            if (locationData.latitude == null || locationData.longitude == null) return;
            LatLng newLatLng = LatLng(locationData.latitude!, locationData.longitude!);
            mapController.animateCamera(CameraUpdate.newLatLng(newLatLng));
            ref.read(mapCameraPositionProvider.notifier).state = newLatLng;
          },
          borderRadius: BorderRadius.circular(5.w),
          child: Container(
            height: 30.h,
            width: 35.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Icon(Icons.my_location, size: 18.w),
          ),
        ),
      ),
    );
  }
}
