import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDetailWidget extends ConsumerWidget {
  const UserDetailWidget({super.key, required this.email, required this.name, required this.photoUrl});
  final String? photoUrl;
  final String? name;
  final String? email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5.w),
          child: CircleAvatar(
            radius: 20.w,
            backgroundColor: Theme.of(context).canvasColor,
            child: photoUrl == null
                ? null
                : CachedNetworkImage(
                    imageUrl: photoUrl!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                    placeholder: (context, url) => CircleAvatar(
                      backgroundColor: Theme.of(context).canvasColor,
                      radius: 17.w,
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: Theme.of(context).canvasColor,
                      radius: 17.w,
                      child: Icon(Icons.error),
                    ),
                  ),
          ),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name ?? '',
              style: TextStyle(fontSize: 12.sp),
            ),
            Text(
              email ?? '',
              style: TextStyle(fontSize: 10.sp),
            ),
          ],
        ),
      ],
    );
  }
}
