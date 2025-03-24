import 'package:adrash_rider/features/auth/view/widgets/logout_btn.dart';
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
          LogoutBtn(),
        ],
      ),
    );
  }
}
