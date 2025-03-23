import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleCard extends ConsumerWidget {
  const VehicleCard({super.key, required this.onTap, required this.title, required this.price, required this.seats});
  final Function() onTap;
  final String title;
  final double price;
  final int seats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.w),
        color: Theme.of(context).canvasColor,
        boxShadow: [BoxShadow(color: Colors.grey.shade200, offset: Offset(2, 4), blurRadius: 10)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(5.w),
          child: Container(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12.sp, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                SizedBox(height: 2.h),
                Text("${price.toStringAsFixed(2)} birr", style: TextStyle(fontSize: 12.sp)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image(image: AssetImage('assets/icon/four_seat_car.png'), height: 80.h, width: 160.w),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("$seats seats", style: TextStyle(fontSize: 12.sp, color: Theme.of(context).primaryColor)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
