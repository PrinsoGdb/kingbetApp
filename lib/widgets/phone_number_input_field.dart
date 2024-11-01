import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart'
    show
        Widget,
        BuildContext,
        TextInputType,
        TextStyle,
        InputBorder,
        OutlineInputBorder,
        BorderSide,
        TextFormField,
        TextEditingController,
        InputDecoration,
        ElevatedButton,
        Colors,
        Container,
        State,
        BoxDecoration,
        Border,
        BorderRadius,
        EdgeInsets,
        FontWeight,
        Row,
        Expanded,
        Text,
        Icon,
        Icons,
        VoidCallback,
        StatefulWidget;
import '../utilities/color.dart';

class CustomPhoneNumberInputField extends StatefulWidget {
  final Country selectedCountry;
  final VoidCallback onPressed;
  final bool readOnly;
  final String? validationError;
  final TextEditingController controller;

  const CustomPhoneNumberInputField(
      {super.key,
      required this.selectedCountry,
      required this.onPressed,
      this.readOnly = false,
      this.validationError,
      required this.controller});

  // countryCodeToEmoji(String countryCode) {
  //   final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
  //   final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
  //   return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  // }

  @override
  State<CustomPhoneNumberInputField> createState() =>
      _CustomPhoneNumberInputFieldState();
}

class _CustomPhoneNumberInputFieldState
    extends State<CustomPhoneNumberInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: AppColor.grayColor,
          border: Border.all(
            color: AppColor.secondaryColor,
            width: 1.0, // Épaisseur de la bordure
          ),
          borderRadius: BorderRadius.circular(8.0), // Rayon de la bordure
        ),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                backgroundColor: AppColor.grayColor,
                textStyle: const TextStyle(
                  color: AppColor.placeholderColor,
                ),
                elevation: 0, // Pas d'ombre
              ),
              child: Row(
                children: [
                  Text('+${widget.selectedCountry.phoneCode}',
                      style: const TextStyle(
                        color: AppColor.placeholderColor,
                      )),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColor.placeholderColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: TextFormField(
                readOnly: widget.readOnly,
                cursorColor: Colors.black.withOpacity(0.5),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  error: widget.validationError != null
                      ? Text("${widget.validationError}", style: TextStyle(color: Colors.red))
                      : null,
                  hintStyle: TextStyle(
                      color: AppColor.placeholderColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                  hintText: "Numéro de téléphone",
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                ),
                controller: widget.controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required'; // Validation logic
                  }
                  return null;
                },
              ),
            ),
          ],
        ));
  }
}
