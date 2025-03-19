import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showEnableLocPermissionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Location Permission', style: TextStyle(fontSize: 14.sp)),
        content: Text('Please enable location permission so that we can get your current location', style: TextStyle(fontSize: 12.sp)),
        actions: [
          TextButton(
            child: Text('Ok', style: TextStyle(fontSize: 12.sp)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
