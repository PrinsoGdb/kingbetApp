import 'dart:ui';

import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        ElevatedButton,
        Text,
        TextStyle,
        VoidCallback,
        Colors,
        EdgeInsets,
        SizedBox,
        RoundedRectangleBorder,
        BorderRadius,
        StatefulWidget,
        State,
        CircularProgressIndicator;
import '../utilities/color.dart';

class CustomElevatedButton extends StatefulWidget {
  final String label;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final bool isSubmitting;
  final bool withRadius;

  const CustomElevatedButton(
      {super.key,
      required this.label,
      this.isSubmitting = false,
      this.withRadius = true,
      this.backgroundColor = AppColor.primaryColor,
      this.onPressed});

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: widget.isSubmitting ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: widget.withRadius
                    ? BorderRadius.circular(100)
                    : BorderRadius.circular(0), // Rayon des coins
              ),
              backgroundColor: widget.backgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            child:widget.isSubmitting
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    )
                  : Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ));
  }
}
