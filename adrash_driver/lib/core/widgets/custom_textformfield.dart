import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData? icon;
  final bool isObsecured;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;
  final int? maxLength;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.icon,
    this.isObsecured = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.textInputType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsecured,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(fontSize: 12.sp),
      keyboardType: textInputType,
      inputFormatters: [
        if (textInputType != null && textInputType == TextInputType.number) ...[
          FilteringTextInputFormatter.digitsOnly,
        ],
        if (maxLength != null) ...[
          LengthLimitingTextInputFormatter(maxLength),
        ]
      ],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12.sp),
        hintStyle: TextStyle(fontSize: 12.sp),
        hintText: hintText,
        prefixIcon: icon == null ? null : Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.w),
        ),
        // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      ),
    );
  }
}

// Usage example:
// CustomTextFormField(
//   label: 'Email',
//   hintText: 'Enter your email',
//   icon: Icons.email,
//   onChanged: (value) => print("Input: $value"),
//   validator: (value) => value!.isEmpty ? 'Email is required' : null,
// )
