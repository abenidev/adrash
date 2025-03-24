import 'package:adrash_rider/core/utils/ui_utils.dart';
import 'package:adrash_rider/core/widgets/loader_manager.dart';
import 'package:adrash_rider/features/auth/view/auth_page.dart';
import 'package:adrash_rider/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutBtn extends ConsumerWidget {
  const LogoutBtn({super.key, this.iconSize});
  final double? iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Logout', style: TextStyle(fontSize: 14.sp)),
              content: Text('Are you sure you want to logout?', style: TextStyle(fontSize: 12.sp)),
              actions: [
                TextButton(
                  child: Text('No', style: TextStyle(fontSize: 12.sp)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Yes', style: TextStyle(fontSize: 12.sp)),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    LoaderManager().showStretchedDots(context);
                    bool isSignedOut = await ref.read(authViewmodelProvider.notifier).signOut();
                    LoaderManager().hide();
                    if (!isSignedOut) {
                      if (context.mounted) {
                        showCustomSnackBar(context, 'Something went wrong while signing you out, Please try again!', bgColor: Colors.red, textColor: Colors.white);
                      }
                      return;
                    }
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthPage()), (route) => false);
                    }
                  },
                )
              ],
            );
          },
        );
      },
      icon: Icon(Icons.logout, size: iconSize ?? 22.w, color: Colors.red),
    );
  }
}
