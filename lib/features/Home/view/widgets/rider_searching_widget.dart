import 'package:adrash/core/widgets/loader_manager.dart';
import 'package:adrash/features/Home/model/route_data.dart';
import 'package:adrash/features/Home/model/user_geocoded_loc.dart';
import 'package:adrash/features/Home/model/vehicle_type.dart';
import 'package:adrash/features/Home/utils/home_utils.dart';
import 'package:adrash/features/Home/view/widgets/detail_row.dart';
import 'package:adrash/features/Home/viewmodel/map_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/ride_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/route_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/user_location_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_location_search/flutter_location_search.dart' as fls;

class RiderSearchingWidget extends ConsumerWidget {
  const RiderSearchingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteData? routeData = ref.watch(routeDataProvider);
    VehicleType? selectedVehicleType = ref.watch(selectedVehicleTypeProvider);
    UserGeocodedLoc? userGeocodedData = ref.watch(userLocationGeocodedDataProvider);
    String locName = userGeocodedData?.name == null ? '' : '${userGeocodedData?.name},';
    String locSubLocality = userGeocodedData?.subLocality == null ? '' : '${userGeocodedData?.subLocality},';
    String locLocality = userGeocodedData?.locality == null ? '' : '${userGeocodedData?.locality}';
    fls.LocationData? destinationLocationData = ref.watch(destinationLocationDataProvider);

    if (routeData == null) {
      return Container();
    }
    if (selectedVehicleType == null) {
      return Container();
    }

    return Container(
      constraints: BoxConstraints(
        minHeight: 200.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.w), topRight: Radius.circular(15.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            child: Text('Ride details', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            child: Row(
              children: [
                Icon(Icons.my_location, size: 16.w),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    '$locName $locSubLocality $locLocality',
                    style: TextStyle(fontSize: 12.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            child: Row(
              children: [
                Icon(Icons.near_me_sharp, size: 16.w),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    '${destinationLocationData?.address}',
                    style: TextStyle(fontSize: 12.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.h),
          Divider(),
          SizedBox(height: 5.h),
          DetailRow(
            title: "Distance:",
            desc: "${(routeData.distanceInMeters / 1000).toStringAsFixed(1)} km",
            iconData: LineIcons.ruler,
          ),
          SizedBox(height: 10.h),
          DetailRow(
            title: "Price (Estimate):",
            desc: "${calculateEconomyPrice(routeData.distanceInMeters).toStringAsFixed(2)} birr",
            iconData: LineIcons.money_bill,
          ),
          SizedBox(height: 10.h),
          DetailRow(
            title: "Vehicle:",
            desc: "${selectedVehicleType.name} (${selectedVehicleType.seat} Seats)",
            iconData: LineIcons.car,
          ),
          SizedBox(height: 15.h),
          LinearProgressIndicator(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text('Looking for drivers...', style: TextStyle(fontSize: 12.sp)),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Are you sure?', style: TextStyle(fontSize: 14.sp)),
                      content: Text('You are about to cancel a trip', style: TextStyle(fontSize: 12.sp)),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            LoaderManager().showThreeArchedCircle(context, showBg: true);
                            await Future.delayed(Duration(milliseconds: 400));
                            LoaderManager().hide();
                            ref.read(rideViewmodelProvider.notifier).cancelRide();
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Yes', style: TextStyle(fontSize: 12.sp)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No', style: TextStyle(fontSize: 12.sp)),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
                elevation: 0,
              ),
              child: Text('Cancel', style: TextStyle(fontSize: 12.sp)),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
