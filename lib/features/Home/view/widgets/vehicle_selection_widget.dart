import 'package:adrash/core/constants/app_consts.dart';
import 'package:adrash/features/Home/model/route_data.dart';
import 'package:adrash/features/Home/utils/home_utils.dart';
import 'package:adrash/features/Home/view/widgets/vehicle_card.dart';
import 'package:adrash/features/Home/viewmodel/map_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/ride_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

class VehicleSelectionWidget extends ConsumerWidget {
  const VehicleSelectionWidget({super.key, required this.onVehicleTypeSelected});
  final Function() onVehicleTypeSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteData? routeData = ref.watch(routeDataProvider);

    if (routeData == null) {
      return Container();
    }

    return Container(
      constraints: BoxConstraints(
        minHeight: 200.h,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.w), topRight: Radius.circular(15.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Text('Select Vehicle', style: TextStyle(fontSize: 12.sp)),
          SizedBox(height: 2.h),
          Row(
            children: [
              Icon(LineIcons.ruler, size: 14.w, color: Theme.of(context).primaryColor),
              SizedBox(width: 5.w),
              Text('Distance:', style: TextStyle(fontSize: 12.sp)),
              SizedBox(width: 5.w),
              Text('${(routeData.distanceInMeters / 1000).toStringAsFixed(1)} km', style: TextStyle(fontSize: 12.sp)),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 150.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: vehicleTypes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: index != 0 ? 10.w : 0),
                  child: VehicleCard(
                    title: vehicleTypes[index].name,
                    price: calculateEconomyPrice(routeData.distanceInMeters),
                    seats: vehicleTypes[index].seat,
                    onTap: () {
                      ref.read(selectedVehicleTypeProvider.notifier).state = vehicleTypes[index];
                      onVehicleTypeSelected();
                    },
                  ),
                );
              },
            ),
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
                          onPressed: () {
                            ref.read(rideViewmodelProvider.notifier).cancelRide();
                            Navigator.of(context).pop();
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
