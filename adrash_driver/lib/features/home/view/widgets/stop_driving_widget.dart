import 'package:adrash_rider/core/models/driver_data.dart';
import 'package:adrash_rider/core/utils/ui_utils.dart';
import 'package:adrash_rider/features/auth/model/user_data.dart';
import 'package:adrash_rider/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:adrash_rider/features/home/view/widgets/base_container.dart';
import 'package:adrash_rider/features/home/view/widgets/driver_active_indicator.dart';
import 'package:adrash_rider/features/home/view/widgets/driver_offline_indicator.dart';
import 'package:adrash_rider/features/home/view/widgets/slide_widget.dart';
import 'package:adrash_rider/features/home/viewmodel/driver_data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StopDrivingWidget extends ConsumerWidget {
  const StopDrivingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserData? userData = ref.watch(authViewmodelProvider);
    // UserGeocodedLoc? userGeocodedData = ref.watch(userLocationGeocodedDataProvider);
    // String locName = userGeocodedData?.name == null ? '' : '${userGeocodedData?.name},';
    // String locSubLocality = userGeocodedData?.subLocality == null ? '' : '${userGeocodedData?.subLocality},';
    // String locLocality = userGeocodedData?.locality == null ? '' : '${userGeocodedData?.locality}';
    // String locationStr = '$locName $locSubLocality $locLocality';

    AsyncValue<DriverData> driverDataStream = ref.watch(driverDataStreamProvider);

    return BaseContainer(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                driverDataStream.when(
                  data: (driverData) {
                    return driverData.isDriverAvailable ? DriverActiveIndicator() : DriverOfflineIndicator();
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (e, stack) => Text('Error!', style: TextStyle(fontSize: 12.sp)),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: SlideWidget(
              label: "Slide to stop",
              onFullSlide: () async {
                if (userData == null) return;
                try {
                  await Future.delayed(Duration(milliseconds: 400));
                  await ref.read(driverDataViewmodelProvider.notifier).updateDriverAvailability(false);
                } catch (e) {
                  if (context.mounted) {
                    showErrorSnackBar(context, '$e');
                  }
                }
              },
            ),
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}
