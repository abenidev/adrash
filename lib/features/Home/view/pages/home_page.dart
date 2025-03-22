import 'package:adrash/core/constants/app_enums.dart';
import 'package:adrash/features/Home/view/pages/setting_page.dart';
import 'package:adrash/features/Home/view/widgets/map_widget.dart';
import 'package:adrash/features/Home/view/widgets/my_location_widget_btn.dart';
import 'package:adrash/features/Home/view/widgets/profile_pic_widget.dart';
import 'package:adrash/features/Home/view/widgets/to_location_pick_widget.dart';
import 'package:adrash/features/Home/viewmodel/user_location_viewmodel.dart';
import 'package:adrash/features/auth/model/user_data.dart';
import 'package:adrash/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late GoogleMapController mapController;
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() async {
      PermissionStatus permissionStatus = await ref.read(userLocationViewmodelProvider.notifier).requestLocationPermission();
      if (permissionStatus == PermissionStatus.granted) {
        //TODO: handle cases when user doesn't allow permission or service
        bool isLocationServiceEnabled = await ref.read(userLocationViewmodelProvider.notifier).requestLocationService();
        if (isLocationServiceEnabled) {
          ref.read(userLocationViewmodelProvider.notifier).getCurrentLocationData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // Initialize location updater
    ref.watch(locationUpdaterProvider);

    // Get the current location from state
    LocationData? currentLocation = ref.watch(currentLocationProvider);
    //
    UserData? userData = ref.watch(authViewmodelProvider);
    UserRole userRole = ref.watch(authViewmodelProvider.notifier).getUserRole();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            MapWidget(),
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
              bottom: 0,
              left: 0,
              right: 0,
              child: ToLocationPickWidget(
                onToLocationTap: () {
                  //
                },
              ),
            ),
            // Center(
            //   child: Text(
            //     "$locName $locSubLocality",
            //     style: TextStyle(fontSize: 20.sp),
            //     maxLines: 1,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),

            //!
            // Center(
            //   child: currentLocation != null ? Text('Lat: ${currentLocation.latitude}, Lng: ${currentLocation.longitude}') : const Text('Waiting for location...'),
            // ),
            //!

            // Positioned(
            //   top: 0,
            //   left: 0,
            //   child: Container(
            //     padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
            //     decoration: BoxDecoration(
            //       color: Theme.of(context).canvasColor,
            //     ),
            //     width: 1.sw,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Padding(
            //           padding: EdgeInsets.only(left: 10.w),
            //           child: CircleAvatar(
            //             backgroundColor: Theme.of(context).canvasColor,
            //             radius: 17.w,
            //             child: ClipRRect(
            //               borderRadius: BorderRadius.circular(50.0),
            //               child: userData != null
            //                   ? Image(
            //                       image: NetworkImage(userData.profilePictureUrl),
            //                     )
            //                   : null,
            //             ),
            //           ),
            //         ),
            //         Container(
            //           width: 150.w,
            //           padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            //           decoration: BoxDecoration(
            //             color: Theme.of(context).canvasColor,
            //             borderRadius: BorderRadius.circular(5.w),
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Icon(Icons.navigation, size: 15.w, color: Colors.green),
            //                   SizedBox(width: 2.w),
            //                   Text(
            //                     'Your location',
            //                     style: TextStyle(fontSize: 10.sp),
            //                   ),
            //                 ],
            //               ),
            //               Text(
            //                 // "$locName $locSubLocality",
            //                 "",
            //                 style: TextStyle(fontSize: 10.sp),
            //                 maxLines: 1,
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //             ],
            //           ),
            //         ),
            //         IconButton(
            //           onPressed: () async {
            //             LoaderManager().show(context);
            //             bool isSignedOut = await ref.read(authViewmodelProvider.notifier).signOut();
            //             if (isSignedOut) {
            //               if (context.mounted) {
            //                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthPage()), (route) => false);
            //               }
            //             }
            //             LoaderManager().hide();
            //           },
            //           icon: Icon(Icons.settings, size: 22.w),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

//
