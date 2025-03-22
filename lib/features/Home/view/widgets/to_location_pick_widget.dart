import 'package:adrash/features/Home/model/user_geocoded_loc.dart';
import 'package:adrash/features/Home/viewmodel/user_location_viewmodel.dart';
import 'package:adrash/features/auth/model/user_data.dart';
import 'package:adrash/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToLocationPickWidget extends ConsumerWidget {
  const ToLocationPickWidget({super.key, required this.onToLocationTap});
  final Function() onToLocationTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserData? userData = ref.watch(authViewmodelProvider);
    UserGeocodedLoc? userGeocodedData = ref.watch(userLocationGeocodedDataProvider);
    String locName = userGeocodedData?.name == null ? '' : '${userGeocodedData?.name},';
    String locSubLocality = userGeocodedData?.subLocality == null ? '' : '${userGeocodedData?.subLocality},';

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
          SizedBox(height: 8.h),
          Text('Where to${userData != null ? ' ${userData.name}' : ''}?', style: TextStyle(fontSize: 12.sp, color: Theme.of(context).primaryColor)),

          SizedBox(height: 8.h),
          Text('From', style: TextStyle(fontSize: 12.sp)),
          SizedBox(height: 5.h),
          Row(
            children: [
              Transform.rotate(
                angle: 45 * (3.1415927 / 180),
                child: Icon(Icons.navigation, color: Colors.green, size: 10.w),
              ),
              SizedBox(width: 4.w),
              Text('Your location', style: TextStyle(fontSize: 8.sp)),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 9.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Text(
              userGeocodedData == null ? "Getting location..." : "$locName $locSubLocality",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade400),
            ),
          ),
          SizedBox(height: 8.h),

          //
          Text('To', style: TextStyle(fontSize: 12.sp)),
          SizedBox(height: 5.h),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onToLocationTap,
                borderRadius: BorderRadius.circular(5.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: Text(
                    "Select address",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
