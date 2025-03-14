import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.hint = 'Select an option',
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: widget.hint,
        labelStyle: TextStyle(fontSize: 12.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.w),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: widget.items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(fontSize: 12.sp),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => selectedValue = value);
        widget.onChanged(value);
      },
      icon: const Icon(Icons.arrow_drop_down),
      validator: (value) => (value == null || value.trim().isEmpty) ? 'Please select an option' : null,
    );
  }
}

// Usage example:
// CustomDropdown(
//   items: ['Option 1', 'Option 2', 'Option 3'],
//   onChanged: (value) => print("Selected: $value"),
// )
