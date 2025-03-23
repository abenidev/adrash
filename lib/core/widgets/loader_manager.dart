import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderManager {
  static final LoaderManager _instance = LoaderManager._internal();
  factory LoaderManager() => _instance;
  LoaderManager._internal();

  OverlayEntry? _overlayEntry;

  // Show Loader
  void show(BuildContext context, {required Widget child, bool showBg = true}) {
    if (_overlayEntry != null) return; // Avoid duplicate loaders

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dimmed Background
          Container(
            color: Colors.black.withValues(alpha: 0.5),
          ),
          // Loader Widget
          Center(
            child: Container(
              height: 40.h,
              width: 50.w,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              decoration: !showBg
                  ? null
                  : BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(5.w),
                    ),
              child: child,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void showStretchedDots(BuildContext context, {bool showBg = true}) {
    show(
      context,
      child: Center(
        child: LoadingAnimationWidget.stretchedDots(
          color: Theme.of(context).primaryColor,
          size: 30.w,
        ),
      ),
      showBg: showBg,
    );
  }

  void showThreeArchedCircle(BuildContext context, {bool showBg = true}) {
    show(
      context,
      child: Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: Theme.of(context).primaryColor,
          size: 30.w,
        ),
      ),
      showBg: showBg,
    );
  }

  // Hide Loader
  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
