import 'package:adrash/core/constants/app_enums.dart';
import 'package:adrash/core/widgets/custom_dropdown.dart';
import 'package:adrash/core/widgets/custom_phone_number_field.dart';
import 'package:adrash/core/widgets/custom_textformfield.dart';
import 'package:adrash/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:adrash/main.dart';
import 'package:dotted_border/dotted_border.dart';
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

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
    _vehicleMakeController = TextEditingController();
    _vehicleModelController = TextEditingController();
    _vehicleYearController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? firebaseUser = ref.watch(authViewmodelProvider.notifier).getFirebaseAuthUser();
    UserRole? selectedUserRole = ref.watch(selectedRoleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(fontSize: 16.sp)),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.w),
                        child: CircleAvatar(
                          radius: 20.w,
                          backgroundColor: Theme.of(context).canvasColor,
                          child: firebaseUser?.photoURL == null
                              ? null
                              : Image(
                                  image: NetworkImage(firebaseUser!.photoURL!),
                                ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firebaseUser?.displayName ?? '',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          Text(
                            firebaseUser?.email ?? '',
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),

                  //Role
                  CustomDropdown(
                    items: [UserRole.driver.name.capitalize, UserRole.rider.name.capitalize],
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
                  if (selectedUserRole == UserRole.driver) ...[
                    Animate(
                      effects: [FadeEffect(duration: Duration(milliseconds: 100)), SlideEffect(begin: Offset(0, -0.2), duration: Duration(milliseconds: 100))],
                      child: Column(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              DottedBorder(
                                // color: Colors.blueAccent, // Border color
                                strokeWidth: 2, // Border thickness
                                dashPattern: [8, 4], // Dots and gaps
                                borderType: BorderType.RRect, // Rounded rectangle
                                radius: Radius.circular(5.w),
                                child: InkWell(
                                  onTap: () {
                                    //
                                  },
                                  borderRadius: BorderRadius.circular(5.w),
                                  child: Container(
                                    height: 80.h,
                                    width: 75.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.w),
                                    ),
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          Icon(LineIcons.camera, size: 36.w),
                                          Positioned(
                                            bottom: -5,
                                            right: -5,
                                            child: Container(
                                              height: 20.h,
                                              width: 20.w,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Icon(Icons.add, size: 16.w, color: Theme.of(context).canvasColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
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
                        ],
                      ),
                    ),
                  ],
                ],
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
                    onPressed: () {
                      //
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
