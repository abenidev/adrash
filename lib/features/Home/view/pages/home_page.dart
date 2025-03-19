import 'package:adrash/features/Home/model/user_geocoded_loc.dart';
import 'package:adrash/features/Home/view/widgets/map_widget.dart';
import 'package:adrash/features/Home/viewmodel/user_location_viewmodel.dart';
import 'package:adrash/features/auth/model/user_data.dart';
import 'package:adrash/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    UserData userData = ref.watch(authViewmodelProvider)!;
    UserGeocodedLoc? userGeocodedData = ref.watch(userLocationGeocodedDataProvider);
    String locName = userGeocodedData?.name == null ? '' : '${userGeocodedData?.name},';
    String locSubLocality = userGeocodedData?.subLocality == null ? '' : '${userGeocodedData?.subLocality},';

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              MapWidget(),
              Positioned(
                top: 10.h,
                left: 0,
                child: SizedBox(
                  width: 1.sw,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).canvasColor,
                          radius: 17.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image(
                              image: NetworkImage(userData.profilePictureUrl),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150.w,
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(5.w),
                          boxShadow: [BoxShadow(color: Colors.grey.shade500, blurRadius: 2.w)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.navigation, size: 15.w, color: Colors.green),
                                SizedBox(width: 2.w),
                                Text(
                                  'Your location',
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              ],
                            ),
                            Text(
                              "$locName $locSubLocality",
                              style: TextStyle(fontSize: 10.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.settings, size: 22.w),
                      ),
                    ],
                  ),
                ),
              ),
              // IconButton(
              //   onPressed: () async {
              //     LoaderManager().show(context);
              //     await ref.read(authViewmodelProvider.notifier).signOut();
              //     LoaderManager().hide();
              //   },
              //   icon: Icon(Icons.remove),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

//
