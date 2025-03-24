import 'package:adrash_rider/features/home/view/pages/setting_page.dart';
import 'package:adrash_rider/features/home/view/widgets/profile_pic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            Positioned(
              top: statusBarHeight + 10.h,
              left: 10.w,
              child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage())),
                child: ProfilePicWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
