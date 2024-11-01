import 'package:flutter/material.dart' show Widget, FloatingLabelBehavior, ValueChanged, State, TextStyle, InputDecoration, Icon, Icons, Colors, BorderRadius, EdgeInsets, FontWeight, DropdownButtonFormField, DropdownMenuItem, OutlineInputBorder, BorderSide, Text, BuildContext, StatefulWidget;
import '../utilities/color.dart';

class CustomSelectField extends StatefulWidget {
  final String placeholder;
  final List<String> itemList;
  final ValueChanged<String?> onChanged;

  const CustomSelectField({super.key, required this.placeholder, required this.itemList, required this.onChanged});

  
  @override
  State<CustomSelectField> createState() =>
      _CustomSelectFieldState();
}

class _CustomSelectFieldState extends State<CustomSelectField> {

  @override
  Widget build(BuildContext context) {
    

    return DropdownButtonFormField<String>(
      value: null,
      onChanged: widget.onChanged,
      items: widget.itemList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
           style: const TextStyle(color: AppColor.placeholderColor, fontSize: 16.0, fontWeight: FontWeight.w400),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        filled: true,
        labelText: widget.placeholder,
        labelStyle: const TextStyle(color: AppColor.placeholderColor, fontSize: 16.0, fontWeight: FontWeight.w400),
        fillColor: AppColor.grayColor,
        hoverColor: AppColor.grayColor,
        focusColor: AppColor.grayColor,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        
      ),
      icon: const Icon(Icons.arrow_drop_down, color: AppColor.placeholderColor),
      dropdownColor: Colors.white,
      style: const TextStyle(color: AppColor.placeholderColor),
    );
  }
}