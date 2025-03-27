import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverOfflineIndicator extends ConsumerWidget {
  const DriverOfflineIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: Colors.red, radius: 5.w),
        SizedBox(width: 3.w),
        Text('Offline', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
