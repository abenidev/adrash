import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPhoneNumberField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final ValueChanged<String>? onChanged;

  const CustomPhoneNumberField({
    super.key,
    this.controller,
    this.label = 'Phone Number',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12.sp),
        hintText: '9XXXXXXXX',
        hintStyle: TextStyle(fontSize: 12.sp),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 12, right: 8),
          child: Text(
            '+251 ',
            style: TextStyle(
              color: Colors.green,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.w),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!('+251$value');
        }
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your phone number';
        }
        // else if (value.length != 10) {
        //   return 'Enter a valid 9-digit phone number';
        // }
        return null;
      },
    );
  }
}

// Usage example:
// CustomPhoneNumberField(
//   controller: phoneController,
//   onChanged: (value) => print("Phone: $value"),
// )
