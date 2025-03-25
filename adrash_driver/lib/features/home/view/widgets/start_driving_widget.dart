import 'package:adrash_rider/core/models/user_geocoded_loc.dart';
import 'package:adrash_rider/features/auth/model/user_data.dart';
import 'package:adrash_rider/features/auth/view/widgets/user_detail_widget.dart';
import 'package:adrash_rider/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:adrash_rider/features/home/view/widgets/base_container.dart';
import 'package:adrash_rider/features/home/view/widgets/slide_widget.dart';
import 'package:adrash_rider/features/home/viewmodel/user_location_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartDrivingWidget extends ConsumerWidget {
  const StartDrivingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserData? userData = ref.watch(authViewmodelProvider);
    UserGeocodedLoc? userGeocodedData = ref.watch(userLocationGeocodedDataProvider);
    String locName = userGeocodedData?.name == null ? '' : '${userGeocodedData?.name},';
    String locSubLocality = userGeocodedData?.subLocality == null ? '' : '${userGeocodedData?.subLocality},';
    String locLocality = userGeocodedData?.locality == null ? '' : '${userGeocodedData?.locality}';
    String locationStr = '$locName $locSubLocality $locLocality';

    return BaseContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Text('Welcome back', style: TextStyle(fontSize: 12.sp, color: Theme.of(context).primaryColor)),
          SizedBox(height: 10.h),

          UserDetailWidget(
            email: userData?.email,
            name: userData?.name,
            photoUrl: userData?.profilePictureUrl,
          ),
          SizedBox(height: 15.h),

          if (locationStr.trim().isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.navigation_outlined, size: 16.w, color: Theme.of(context).primaryColor),
                SizedBox(width: 5.w),
                Text('Your location', style: TextStyle(fontSize: 12.sp)),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
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
            SizedBox(height: 15.h),
          ],

          //
          SlideWidget(
            label: "Slide to start",
            onFullSlide: () async {
              await Future.delayed(const Duration(seconds: 2));
            },
          ),
        ],
      ),
    );
  }
}
