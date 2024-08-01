import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';

class IField extends StatelessWidget {
  const IField({
    required this.controller,
    this.filled = false,
    this.obscureText = false,
    this.readOnly = false,
    super.key,
    this.validator,
    this.fillColour,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
    this.prefixWidget,
    this.contentPadding,
    this.isPrefix = false,
    this.maxLength,
    this.maxLines,
    this.onlyNumbers = false,
    this.overrideValidator = false,
    this.focusNode,
    this.onlyStrings = false,
    this.onEditingComplete,
    this.firstCaptitalize = true,
    this.onChanged,
  });

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool filled;
  final Color? fillColour;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool overrideValidator;
  final TextStyle? hintStyle;
  final double? contentPadding;
  final Widget? prefixWidget;
  final bool isPrefix;
  final int? maxLength;
  final int? maxLines;
  final bool onlyNumbers;
  final FocusNode? focusNode;
  final bool onlyStrings;
  final VoidCallback? onEditingComplete;
  final bool firstCaptitalize;
  final void Function(String)? onChanged;

  String capitalizeFirstLetterOfEachWord(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width * .15;
    return Stack(
      children: [
        if (isPrefix) ...[
          SizedBox(
            width: width,
            height: 47,
            child: Center(
              child: prefixWidget,
            ),
          ),
          Positioned(
            left: width,
            height: 47,
            child: VerticalDivider(
              width: 2,
              color: Colors.grey.shade500,
            ),
          ),
        ],
        TextFormField(
          onEditingComplete: onEditingComplete,
          onChanged: onChanged ??
              (text) {
                if (firstCaptitalize) {
                  final capitalizedText = capitalizeFirstLetterOfEachWord(text);
                  if (capitalizedText != text) {
                    controller.value = controller.value.copyWith(
                      text: capitalizedText,
                      selection: TextSelection.collapsed(
                        offset: capitalizedText.length,
                      ),
                    );
                  }
                }
              },
          controller: controller,
          focusNode: focusNode,
          maxLines: maxLines ?? 1,
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength ?? 40),
            if (onlyNumbers) FilteringTextInputFormatter.digitsOnly,
            if (onlyStrings)
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
          ],
          validator: overrideValidator
              ? validator
              : (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return validator?.call(value);
                },
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1),
            ),
            // errorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(1),
            // ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade500),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: context.theme.primaryColor,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isPrefix ? (width + 20) : (contentPadding ?? 15),
            ),
            filled: filled,
            fillColor: fillColour,
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: hintStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ],
    );
  }
}
