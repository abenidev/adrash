import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOutlinedButton extends ConsumerWidget {
  const CustomOutlinedButton({super.key, required this.onPressed, this.height, required this.child, this.buttonStyle, this.width});
  final Function()? onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height ?? 35.h,
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: child,
      ),
    );
  }
}

//
class CustomElevatedButton extends ConsumerWidget {
  const CustomElevatedButton({super.key, required this.onPressed, this.height, required this.child, this.buttonStyle, this.width});
  final Function()? onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height ?? 35.h,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: child,
      ),
    );
  }
}
