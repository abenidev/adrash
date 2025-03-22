import 'package:adrash/features/auth/model/user_data.dart';
import 'package:adrash/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePicWidget extends ConsumerWidget {
  const ProfilePicWidget({super.key, this.url});
  final String? url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserData? userData = ref.watch(authViewmodelProvider);

    if (userData == null) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).canvasColor,
        radius: 17.w,
      );
    }

    return CircleAvatar(
      backgroundColor: Theme.of(context).canvasColor,
      radius: 17.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: CachedNetworkImage(
          imageUrl: url ?? userData.profilePictureUrl,
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
    );
  }
}
