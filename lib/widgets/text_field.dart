import 'package:flutter/material.dart'
    show
        Widget,
        TextInputType,
        TextStyle,
        OutlineInputBorder,
        BorderSide,
        TextFormField,
        InputDecoration,
        FormFieldValidator,
        TextEditingController,
        IconButton,
        State,
        Icon,
        Icons,
        Text,
        Colors,
        BorderRadius,
        EdgeInsets,
        FontWeight,
        VoidCallback,
        BuildContext,
        StatefulWidget;
import '../utilities/color.dart';

String? defaultValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Ce champ est requis';
  }
  return null;
}

class CustomTextField extends StatefulWidget {
  final TextInputType type;
  final String placeholder;
  final bool obscureText;
  final VoidCallback? onPressed;
  final double radius;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final String? validationError;


  const CustomTextField(
      {super.key,
      required this.type,
      required this.placeholder,
      required this.obscureText,
      this.onPressed,
      this.validator = defaultValidator,
      this.readOnly = false,
      required this.radius,
      this.validationError,
      this.controller});
    

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.type,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      cursorColor: Colors.black.withOpacity(0.5),
      decoration: InputDecoration(
        error: widget.validationError != null ? Text("${widget.validationError}", style: TextStyle(color: Colors.red),): null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
        hintText: widget.placeholder,
        hintStyle: const TextStyle(
            color: AppColor.placeholderColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w400),
        filled: true,
        fillColor: AppColor.grayColor,
        hoverColor: AppColor.grayColor,
        focusColor: AppColor.grayColor,
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
        suffixIcon: widget.type == TextInputType.visiblePassword
            ? IconButton(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                icon: Icon(
                  widget.obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColor.primaryColor,
                ),
                onPressed: widget.onPressed,
              )
            : null,
      ),
      controller: widget.controller,
      validator: widget.validator,
    );
  }
}