import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderManager {
  static final LoaderManager _instance = LoaderManager._internal();
  factory LoaderManager() => _instance;
  LoaderManager._internal();

  OverlayEntry? _overlayEntry;

  // Show Loader
  void show(BuildContext context) {
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
            child: LoadingAnimationWidget.stretchedDots(
              color: Colors.white,
              size: 50.w,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // Hide Loader
  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
