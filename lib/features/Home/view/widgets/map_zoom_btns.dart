import 'package:adrash/features/Home/viewmodel/map_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapZoomBtns extends ConsumerWidget {
  const MapZoomBtns({super.key});

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
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final currentZoom = await mapController.getZoomLevel();
                mapController.animateCamera(CameraUpdate.zoomTo(currentZoom + 1));
              },
              borderRadius: BorderRadius.circular(5.w),
              child: Container(
                height: 30.h,
                width: 35.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Icon(Icons.add, size: 18.w),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final currentZoom = await mapController.getZoomLevel();
                mapController.animateCamera(CameraUpdate.zoomTo(currentZoom - 1));
              },
              borderRadius: BorderRadius.circular(5.w),
              child: Container(
                height: 30.h,
                width: 35.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Icon(Icons.remove, size: 18.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
