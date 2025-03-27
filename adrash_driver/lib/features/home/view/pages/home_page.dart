import 'package:adrash_rider/core/models/driver_data.dart';
import 'package:adrash_rider/features/home/view/pages/setting_page.dart';
import 'package:adrash_rider/features/home/view/widgets/map_widget.dart';
import 'package:adrash_rider/features/home/view/widgets/map_zoom_btns.dart';
import 'package:adrash_rider/features/home/view/widgets/my_location_widget_btn.dart';
import 'package:adrash_rider/features/home/view/widgets/profile_pic_widget.dart';
import 'package:adrash_rider/features/home/view/widgets/start_driving_widget.dart';
import 'package:adrash_rider/features/home/view/widgets/stop_driving_widget.dart';
import 'package:adrash_rider/features/home/viewmodel/driver_data_viewmodel.dart';
import 'package:adrash_rider/features/home/viewmodel/user_location_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() async {
      PermissionStatus permissionStatus = await ref.read(userLocationViewmodelProvider.notifier).requestLocationPermission();
      if (permissionStatus == PermissionStatus.granted) {
        //TODO: handle cases when user doesn't allow permission or service
        bool isLocationServiceEnabled = await ref.read(userLocationViewmodelProvider.notifier).requestLocationService();
        if (isLocationServiceEnabled) {
          await ref.read(userLocationViewmodelProvider.notifier).getCurrentLocationData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // Initialize location updater
    ref.watch(locationUpdaterProvider);

    //
    AsyncValue<DriverData> driverDataStream = ref.watch(driverDataStreamProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: MapWidget(),
            ),
            Positioned(
              top: statusBarHeight + 10.h,
              left: 10.w,
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage())),
                child: ProfilePicWidget(),
              ),
            ),
            Positioned(
              top: statusBarHeight + 10.h,
              right: 10.w,
              child: MyLocationWidgetBtn(),
            ),
            Positioned(
              top: statusBarHeight + 10.h + 50.h,
              right: 10.w,
              child: MapZoomBtns(),
            ),

            //
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Animate(
                effects: [FadeEffect(), SlideEffect()],
                child: driverDataStream.when(
                  data: (driverData) {
                    return !driverData.isDriverAvailable ? StartDrivingWidget() : StopDrivingWidget();
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (e, stack) => Text('Error!', style: TextStyle(fontSize: 12.sp)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
