import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverActiveIndicator extends ConsumerWidget {
  const DriverActiveIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: Colors.green, radius: 5.w),
        SizedBox(width: 3.w),
        Text('Active', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
