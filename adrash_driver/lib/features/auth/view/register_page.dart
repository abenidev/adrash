import 'package:adrash_rider/core/constants/app_enums.dart';
import 'package:adrash_rider/core/constants/app_strings.dart';
import 'package:adrash_rider/core/utils/app_utils.dart';
import 'package:adrash_rider/core/utils/ui_utils.dart';
import 'package:adrash_rider/core/widgets/custom_dropdown.dart';
import 'package:adrash_rider/core/widgets/custom_phone_number_field.dart';
import 'package:adrash_rider/core/widgets/custom_textformfield.dart';
import 'package:adrash_rider/core/widgets/loader_manager.dart';
import 'package:adrash_rider/features/auth/model/user_data.dart';
import 'package:adrash_rider/features/auth/model/vehicle_data.dart';
import 'package:adrash_rider/features/auth/view/widgets/logout_btn.dart';
import 'package:adrash_rider/features/auth/view/widgets/user_detail_widget.dart';
import 'package:adrash_rider/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:adrash_rider/features/home/view/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

final selectedRoleProvider = StateProvider<UserRole?>((ref) {
  return null;
});

final selectedPhotosProvider = StateProvider<List<String>>((ref) {
  return [];
});

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late TextEditingController _phoneNumberController;
  late TextEditingController _vehicleMakeController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleYearController;
  late TextEditingController _vehicleLicensePlateController;
  late TextEditingController _vehicleSeatsController;
  late TextEditingController _vehicleColorController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
    _vehicleMakeController = TextEditingController();
    _vehicleModelController = TextEditingController();
    _vehicleYearController = TextEditingController();
    _vehicleLicensePlateController = TextEditingController();
    _vehicleSeatsController = TextEditingController();
    _vehicleColorController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    _vehicleLicensePlateController.dispose();
    _vehicleSeatsController.dispose();
    _vehicleColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? firebaseUser = ref.watch(authViewmodelProvider.notifier).getFirebaseAuthUser();
    UserRole? selectedUserRole = ref.watch(selectedRoleProvider);
    // List<String> selectedPhotos = ref.watch(selectedPhotosProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(fontSize: 16.sp)),
        actions: [
          LogoutBtn(),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    UserDetailWidget(
                      email: firebaseUser?.email,
                      name: firebaseUser?.displayName,
                      photoUrl: firebaseUser?.photoURL,
                    ),

                    SizedBox(height: 15.h),

                    //Role
                    CustomDropdown(
                      items: [UserRole.driver.name.capitalize],
                      hint: 'Select a role',
                      onChanged: (value) {
                        if (value == null) return;
                        UserRole selectedUserRole = value.toLowerCase().toUserRole;
                        ref.read(selectedRoleProvider.notifier).state = selectedUserRole;
                      },
                    ),

                    SizedBox(height: 10.h),
                    CustomPhoneNumberField(
                      controller: _phoneNumberController,
                    ),

                    //vehicle detail
                    Animate(
                      effects: [FadeEffect(duration: Duration(milliseconds: 300))],
                      child: Expanded(
                        child: ListView(
                          children: [
                            SizedBox(height: 15.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Vehicle Details', style: TextStyle(fontSize: 12.sp)),
                              ],
                            ),
                            Divider(),
                            SizedBox(height: 5.h),
                            // SingleChildScrollView(
                            //   scrollDirection: Axis.horizontal,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       DottedBorder(
                            //         strokeWidth: 2, // Border thickness
                            //         dashPattern: [8, 4], // Dots and gaps
                            //         borderType: BorderType.RRect, // Rounded rectangle
                            //         radius: Radius.circular(5.w),
                            //         child: InkWell(
                            //           onTap: () {
                            //             if (selectedPhotos.length >= 3) {
                            //               showCustomSnackBar(context, 'You can only add up to 3 photos');
                            //               return;
                            //             }
                            //             showPhotoSelectorModal(
                            //               context,
                            //               ref,
                            //               onFileSelected: (selectedImageFile) async {
                            //                 if (selectedImageFile == null) return;
                            //                 File? savedImageFile = await ImagePickerHelper.getSavedImageFile(selectedImageFile);
                            //                 if (savedImageFile == null) return;
                            //                 List<String> oldPhotosState = ref.read(selectedPhotosProvider);
                            //                 ref.read(selectedPhotosProvider.notifier).state = [...oldPhotosState, savedImageFile.path];
                            //               },
                            //             );
                            //           },
                            //           borderRadius: BorderRadius.circular(5.w),
                            //           child: Container(
                            //             height: 80.h,
                            //             width: 75.w,
                            //             decoration: BoxDecoration(
                            //               borderRadius: BorderRadius.circular(5.w),
                            //             ),
                            //             child: Center(
                            //               child: Stack(
                            //                 children: [
                            //                   Icon(LineIcons.camera, size: 36.w),
                            //                   Positioned(
                            //                     bottom: -5,
                            //                     right: -5,
                            //                     child: Container(
                            //                       height: 20.h,
                            //                       width: 20.w,
                            //                       decoration: BoxDecoration(
                            //                         color: Theme.of(context).primaryColor,
                            //                         shape: BoxShape.circle,
                            //                       ),
                            //                       child: Center(
                            //                         child: Icon(Icons.add, size: 16.w, color: Theme.of(context).canvasColor),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       ...selectedPhotos.map(
                            //         (photo) {
                            //           return Stack(
                            //             children: [
                            //               Container(
                            //                 height: 80.h,
                            //                 width: 75.w,
                            //                 margin: EdgeInsets.only(left: 5.w),
                            //                 decoration: BoxDecoration(
                            //                   borderRadius: BorderRadius.circular(5.w),
                            //                 ),
                            //                 child: ClipRRect(
                            //                   borderRadius: BorderRadius.circular(5.w),
                            //                   child: Image.file(File(photo), fit: BoxFit.cover),
                            //                 ),
                            //               ),
                            //               Positioned(
                            //                 top: 0,
                            //                 right: 0,
                            //                 child: GestureDetector(
                            //                   onTap: () async {
                            //                     // Remove photo from list
                            //                     ref.read(selectedPhotosProvider.notifier).state = selectedPhotos.where((photoPath) => photoPath != photo).toList();
                            //                     await ImagePickerHelper.removeAlreadyExistingPhoto(photo);
                            //                   },
                            //                   child: Container(
                            //                     height: 20.h,
                            //                     width: 20.w,
                            //                     decoration: BoxDecoration(
                            //                       color: Theme.of(context).primaryColor,
                            //                       shape: BoxShape.circle,
                            //                     ),
                            //                     child: Center(
                            //                       child: Icon(Icons.close, size: 16.w, color: Theme.of(context).canvasColor),
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           );
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(height: 10.h),
                            CustomTextFormField(
                              controller: _vehicleMakeController,
                              label: 'Make',
                              hintText: 'Toyota',
                              textInputType: TextInputType.name,
                              icon: LineIcons.car,
                              validator: (value) => value!.isEmpty ? 'Make is required' : null,
                            ),
                            SizedBox(height: 10.h),
                            CustomTextFormField(
                              controller: _vehicleModelController,
                              label: 'Model',
                              hintText: 'Corolla',
                              textInputType: TextInputType.name,
                              icon: LineIcons.car_side,
                              validator: (value) => value!.isEmpty ? 'Model is required' : null,
                            ),
                            SizedBox(height: 10.h),
                            CustomTextFormField(
                              controller: _vehicleYearController,
                              label: 'Year',
                              hintText: '2021',
                              textInputType: TextInputType.number,
                              icon: LineIcons.calendar,
                              maxLength: 4,
                              validator: (value) => value!.isEmpty ? 'Year is required' : null,
                            ),
                            SizedBox(height: 5.h),
                            CustomTextFormField(
                              controller: _vehicleLicensePlateController,
                              label: 'License Plate Number',
                              hintText: 'B23451',
                              textInputType: TextInputType.text,
                              icon: Icons.car_rental,
                              validator: (value) => value!.isEmpty ? 'License Plate Number is required' : null,
                            ),
                            SizedBox(height: 5.h),
                            CustomTextFormField(
                              controller: _vehicleColorController,
                              label: 'Color',
                              hintText: 'Silver',
                              textInputType: TextInputType.text,
                              icon: LineIcons.palette,
                              validator: (value) => value!.isEmpty ? 'Color is required' : null,
                            ),
                            SizedBox(height: 5.h),
                            CustomTextFormField(
                              controller: _vehicleSeatsController,
                              label: 'Seats',
                              hintText: '4',
                              textInputType: TextInputType.number,
                              icon: LineIcons.chair,
                              maxLength: 2,
                              validator: (value) => value!.isEmpty ? 'Seats is required' : null,
                            ),
                            SizedBox(height: 120.h),

                            //
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h, top: 5.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
                child: SizedBox(
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (selectedUserRole == null) {
                          showCustomSnackBar(context, 'Please select a role');
                          return;
                        }

                        // if (selectedPhotos.isEmpty && selectedUserRole == UserRole.driver) {
                        //   showCustomSnackBar(context, 'Please add at least one photo');
                        //   return;
                        // }

                        UserData? newUserData;

                        // register user
                        if (selectedUserRole == UserRole.driver) {
                          newUserData = UserData(
                            id: getUuid(),
                            docDataId: '',
                            name: firebaseUser?.displayName ?? kUnknown,
                            email: firebaseUser?.email ?? kUnknown,
                            phoneNumber: '+251${_phoneNumberController.text.trim()}',
                            role: selectedUserRole.name,
                            rating: 0,
                            profilePictureUrl: firebaseUser?.photoURL ?? kUnknown,
                            lastLocLat: 0,
                            lastLocLong: 0,
                            vehicleData: VehicleData(
                              id: getUuid(),
                              make: _vehicleMakeController.text.trim(),
                              model: _vehicleModelController.text.trim(),
                              year: int.parse(_vehicleYearController.text.trim()),
                              licensePlate: _vehicleLicensePlateController.text.trim(),
                              color: _vehicleColorController.text.trim(),
                              seats: int.parse(_vehicleSeatsController.text.trim()),
                              // vehicleImages: selectedPhotos,
                            ),
                          );
                        }

                        if (newUserData == null) return;

                        try {
                          LoaderManager().showStretchedDots(context);
                          UserData _ = await ref.read(authViewmodelProvider.notifier).addUserData(newUserData);
                          LoaderManager().hide();
                          if (context.mounted) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                          }
                        } catch (e) {
                          LoaderManager().hide();
                          if (context.mounted) {
                            showCustomSnackBar(context, '$e');
                          }
                          return;
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
