import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/res/app_colors.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.label,
    this.onPressed,
    this.buttonColor,
    this.labelColor,
    this.textStyle,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? labelColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? AppColors.lightPrimaryColor,
        foregroundColor: labelColor ?? Colors.white,
        minimumSize: const Size(double.maxFinite, 50),
      ),
      child: Text(
        label,
        style: textStyle ?? p16.copyWith(letterSpacing: 1),
      ),
    );
  }
}
