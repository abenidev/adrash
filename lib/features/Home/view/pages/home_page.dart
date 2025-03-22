import 'package:adrash/features/Home/model/user_geocoded_loc.dart';
import 'package:adrash/features/Home/view/widgets/map_widget.dart';
import 'package:adrash/features/Home/viewmodel/user_location_viewmodel.dart';
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
      //!
      PermissionStatus permissionStatus = await ref.read(userLocationViewmodelProvider.notifier).requestLocationPermission();
      if (permissionStatus == PermissionStatus.granted) {
        //TODO: handle cases when user doesn't allow permission or service
        bool isLocationServiceEnabled = await ref.read(userLocationViewmodelProvider.notifier).requestLocationService();
        if (isLocationServiceEnabled) {
          ref.read(userLocationViewmodelProvider.notifier).getCurrentLocationData();
        }
      }
      //!
      // UserRole userRole = ref.read(authViewmodelProvider.notifier).getUserRole();
      // if (userRole == UserRole.rider) {
      //   showModalBottomSheet(
      //     context: context,
      //     isDismissible: false,
      //     enableDrag: false,
      //     isScrollControlled: true,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      //     ),
      //     builder: (context) {
      //       UserGeocodedLoc? userGeocodedData = ref.watch(userLocationGeocodedDataProvider);
      //       String locName = userGeocodedData?.name == null ? '' : '${userGeocodedData?.name},';
      //       String locSubLocality = userGeocodedData?.subLocality == null ? '' : '${userGeocodedData?.subLocality},';

      //       return WillPopScope(
      //         onWillPop: () async {
      //           final now = DateTime.now();
      //           final exitTimeGap = Duration(seconds: 2);

      //           if (lastPressed == null || now.difference(lastPressed!) > exitTimeGap) {
      //             lastPressed = now;
      //             showCustomSnackBar(context, 'Press again to exit');
      //             return false; // Don't exit the app
      //           }
      //           SystemNavigator.pop();
      //           return true;
      //         },
      //         child: Container(
      //           decoration: BoxDecoration(),
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               SizedBox(height: 10.h),
      //               Container(
      //                 padding: EdgeInsets.only(right: 20.w),
      //                 child: Row(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     EasyStepper(
      //                       activeStep: 0,
      //                       internalPadding: 0,
      //                       showLoadingAnimation: false,
      //                       stepRadius: 8.w,
      //                       showStepBorder: true,
      //                       direction: Axis.vertical,
      //                       steps: [
      //                         EasyStep(
      //                           customStep: CircleAvatar(
      //                             radius: 8.w,
      //                             backgroundColor: Theme.of(context).primaryColor,
      //                           ),
      //                         ),
      //                         EasyStep(
      //                           customStep: CircleAvatar(
      //                             radius: 8.w,
      //                             backgroundColor: Theme.of(context).primaryColor,
      //                             child: Icon(
      //                               Icons.arrow_downward_outlined,
      //                               size: 10.w,
      //                               color: Colors.white,
      //                             ),
      //                           ),
      //                         ),
      //                       ],
      //                       onStepReached: (index) {},
      //                     ),
      //                     Expanded(
      //                       child: Padding(
      //                         padding: EdgeInsets.only(top: 15.h),
      //                         child: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Text(
      //                               'From',
      //                               style: TextStyle(fontSize: 10.sp),
      //                             ),
      //                             SizedBox(height: 3.h),
      //                             Container(
      //                               width: double.infinity,
      //                               height: 35.h,
      //                               padding: EdgeInsets.only(left: 10.w),
      //                               decoration: BoxDecoration(
      //                                 border: Border.all(color: Colors.grey.shade300),
      //                                 borderRadius: BorderRadius.circular(5.w),
      //                               ),
      //                               child: Column(
      //                                 mainAxisAlignment: MainAxisAlignment.center,
      //                                 crossAxisAlignment: CrossAxisAlignment.start,
      //                                 children: [
      //                                   Text(
      //                                     "$locName $locSubLocality",
      //                                     style: TextStyle(fontSize: 12.sp, color: Colors.grey),
      //                                     maxLines: 1,
      //                                     overflow: TextOverflow.ellipsis,
      //                                   ),
      //                                 ],
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //               SizedBox(height: 25.h),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   );
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize location updater
    ref.watch(locationUpdaterProvider);

    // Get the current location from state
    LocationData? currentLocation = ref.watch(currentLocationProvider);
    UserGeocodedLoc? userGeocodedData = ref.watch(userLocationGeocodedDataProvider);
    String locName = userGeocodedData?.name == null ? '' : '${userGeocodedData?.name},';
    String locSubLocality = userGeocodedData?.subLocality == null ? '' : '${userGeocodedData?.subLocality},';

    // UserData? userData = ref.watch(authViewmodelProvider);
    // UserRole userRole = ref.watch(authViewmodelProvider.notifier).getUserRole();

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              MapWidget(),
              Center(
                child: Text(
                  "$locName $locSubLocality",
                  style: TextStyle(fontSize: 20.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Center(
              //   child: currentLocation != null ? Text('Lat: ${currentLocation.latitude}, Lng: ${currentLocation.longitude}') : const Text('Waiting for location...'),
              // ),

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
      ),
    );
  }
}

//
