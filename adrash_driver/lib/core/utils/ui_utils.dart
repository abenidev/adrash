import 'dart:io';

import 'package:adrash_rider/core/constants/app_enums.dart';
import 'package:adrash_rider/core/helpers/image_picker_helper.dart';
import 'package:adrash_rider/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

Future<void> showCustomModalBottomSheet(
  BuildContext context,
  Widget child, {
  double topBorderRadius = 10.0,
  bool canBackPop = true,
  bool isDismissible = true,
  bool enableDrag = true,
}) async {
  await showModalBottomSheet(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(topBorderRadius)),
    ),
    builder: (context) {
      return PopScope(
        canPop: canBackPop,
        child: child,
      );
    },
  );
}

Future<void> showPhotoSelectorModal(
  BuildContext context,
  WidgetRef ref, {
  bool isDismissible = true,
  bool enableDrag = true,
  Function(File?)? onFileSelected,
  Function(UserPhotoModalSelectedOption)? onOptionSelect,
}) async {
  await showCustomModalBottomSheet(
    context,
    Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15.h),
          CustomOutlinedButton(
            onPressed: () async {
              if (onOptionSelect != null) {
                Navigator.pop(context);
                return onOptionSelect(UserPhotoModalSelectedOption.camera);
              }

              if (onFileSelected != null) {
                File? pickedFile = await ImagePickerHelper.pickFromCamera();
                if (context.mounted) {
                  File? croppedImage = await ImagePickerHelper.cropImageFile(context, pickedFile!);
                  onFileSelected(croppedImage);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              }
            },
            width: 250.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LineIcons.camera, size: 14.w),
                SizedBox(width: 10.w),
                Text(
                  'Camera',
                  style: TextStyle(fontSize: 13.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          CustomOutlinedButton(
            onPressed: () async {
              if (onOptionSelect != null) {
                Navigator.pop(context);
                return onOptionSelect(UserPhotoModalSelectedOption.gallery);
              }

              if (onFileSelected != null) {
                File? pickedFile = await ImagePickerHelper.pickFromGallery();
                if (context.mounted) {
                  File? croppedImage = await ImagePickerHelper.cropImageFile(context, pickedFile!);
                  onFileSelected(croppedImage);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              }
            },
            width: 250.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo, size: 14.w),
                SizedBox(width: 10.w),
                Text(
                  'Gallery',
                  style: TextStyle(fontSize: 13.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
        ],
      ),
    ),
    isDismissible: isDismissible,
    enableDrag: enableDrag,
  );
}

void showCustomSnackBar(BuildContext context, String text, {Color bgColor = Colors.black, Color textColor = Colors.white}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text, style: TextStyle(color: textColor)),
      backgroundColor: bgColor,
    ),
  );
}

void showErrorSnackBar(BuildContext context, String text, {Color bgColor = Colors.red, Color textColor = Colors.white}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text, style: TextStyle(color: textColor)),
      backgroundColor: bgColor,
    ),
  );
}
