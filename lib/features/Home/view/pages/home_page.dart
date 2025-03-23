import 'package:adrash/core/utils/ui_utils.dart';
import 'package:adrash/core/widgets/loader_manager.dart';
import 'package:adrash/features/Home/model/route_data.dart';
import 'package:adrash/features/Home/model/vehicle_type.dart';
import 'package:adrash/features/Home/view/pages/setting_page.dart';
import 'package:adrash/features/Home/view/widgets/map_widget.dart';
import 'package:adrash/features/Home/view/widgets/map_zoom_btns.dart';
import 'package:adrash/features/Home/view/widgets/my_location_widget_btn.dart';
import 'package:adrash/features/Home/view/widgets/profile_pic_widget.dart';
import 'package:adrash/features/Home/view/widgets/destination_location_pick_widget.dart';
import 'package:adrash/features/Home/view/widgets/vehicle_selection_widget.dart';
import 'package:adrash/features/Home/viewmodel/map_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/ride_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/route_viewmodel.dart';
import 'package:adrash/features/Home/viewmodel/user_location_viewmodel.dart';
import 'package:adrash/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location_search/flutter_location_search.dart' as fls;
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
    // LocationData? currentLocation = ref.watch(currentLocationProvider);
    //
    // UserData? userData = ref.watch(authViewmodelProvider);
    // UserRole userRole = ref.watch(authViewmodelProvider.notifier).getUserRole();
    // fls.LocationData? destinationLocationData = ref.watch(destinationLocationDataProvider);

    RouteData? routeData = ref.watch(routeDataProvider);
    VehicleType? selectedVehicleType = ref.watch(selectedVehicleTypeProvider);

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
              top: statusBarHeight + 10.h + 50.h,
              right: 10.w,
              child: MapZoomBtns(),
            ),

            //
            if (routeData == null) ...[
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: DestinationLocationPickWidget(
                  onToLocationTap: () async {
                    fls.LocationData? destinationLocData;
                    try {
                      destinationLocData = await fls.LocationSearch.show(
                        context: context,
                        userAgent: fls.UserAgent(appName: 'Adrash', email: 'support@adrash.com'),
                        mode: fls.Mode.fullscreen,
                        searchBarBackgroundColor: Theme.of(context).canvasColor,
                      );
                    } catch (e) {
                      logger.e(e);
                      if (context.mounted) {
                        showCustomSnackBar(context, "Coundn't get location. Please try again!", bgColor: Colors.red, textColor: Colors.white);
                      }
                    }

                    try {
                      if (context.mounted) LoaderManager().showThreeArchedCircle(context, showBg: true);
                      await ref.read(routeViewmodelProvider.notifier).getRouteData(destinationLocData);
                      LoaderManager().hide();
                    } catch (e) {
                      logger.e(e);
                      LoaderManager().hide();
                      if (context.mounted) {
                        showCustomSnackBar(context, "$e", bgColor: Colors.red, textColor: Colors.white);
                      }
                    }
                  },
                ),
              ),
            ],

            if (routeData != null && selectedVehicleType == null) ...[
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VehicleSelectionWidget(
                  onVehicleTypeSelected: () {
                    //
                  },
                ),
              ),
            ],

            if (routeData != null && selectedVehicleType != null) ...[
              //
            ],

            //
          ],
        ),
      ),
    );
  }
}

//
