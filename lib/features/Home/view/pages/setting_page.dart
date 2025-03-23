import 'package:adrash/core/widgets/loader_manager.dart';
import 'package:adrash/features/auth/view/auth_page.dart';
import 'package:adrash/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting', style: TextStyle(fontSize: 16.sp)),
        actions: [
          IconButton(
            onPressed: () async {
              LoaderManager().showStretchedDots(context);
              bool isSignedOut = await ref.read(authViewmodelProvider.notifier).signOut();
              if (isSignedOut) {
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthPage()), (route) => false);
                }
              }
              LoaderManager().hide();
            },
            icon: Icon(Icons.settings, size: 22.w),
          ),
        ],
      ),
    );
  }
}
