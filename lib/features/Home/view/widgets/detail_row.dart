import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailRow extends ConsumerWidget {
  const DetailRow({super.key, required this.title, required this.desc, required this.iconData});
  final IconData iconData;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      margin: EdgeInsets.zero, // No margin
      child: Row(
        children: [
          Row(
            children: [
              Icon(iconData, size: 14.w, color: Theme.of(context).primaryColor),
              SizedBox(width: 15.w),
              Text(title, style: TextStyle(fontSize: 12.sp)),
            ],
          ),
          Spacer(),
          Text(desc, style: TextStyle(fontSize: 12.sp)),
        ],
      ),
    );
  }
}
