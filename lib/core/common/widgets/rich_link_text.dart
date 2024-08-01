import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';

class RichLinkText extends StatelessWidget {
  const RichLinkText({
    required this.label,
    super.key,
    this.onPressed,
    this.color,
    this.textStyle,
  });

  final VoidCallback? onPressed;
  final Color? color;
  final TextStyle? textStyle;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Ink(
        child: Text(
          label,
          style: textStyle ??
              p16.copyWith(
                color: color ?? context.theme.primaryColor,
              ),
        ),
      ),
    );
  }
}
