import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slide_action/slide_action.dart';

class SlideWidget extends ConsumerWidget {
  const SlideWidget({super.key, required this.label, required this.onFullSlide});
  final String label;
  final FutureOr<void> Function()? onFullSlide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SlideAction(
      stretchThumb: true,
      trackBuilder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.w),
            color: Theme.of(context).canvasColor,
            boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          child: Center(
            child: Text(label, style: TextStyle(fontSize: 12.sp)),
          ),
        );
      },
      thumbBuilder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: state.isPerformingAction ? Theme.of(context).secondaryHeaderColor : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15.w),
          ),
          child: state.isPerformingAction ? const CupertinoActivityIndicator() : const Icon(Icons.chevron_right, color: Colors.white),
        );
      },
      action: onFullSlide,
    );
  }
}
