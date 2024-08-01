import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/common/widgets/i_field.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/res/gap_ex.dart';

class EditTitleTextField extends StatelessWidget {
  const EditTitleTextField({
    required this.controller,
    required this.titleText,
    this.focusNode,
    this.hintText,
    this.onEditingComplete,
    this.onlyStrings = true,
    this.readOnly = false,
    super.key,
  });

  final TextEditingController controller;
  final String titleText;
  final String? hintText;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final bool onlyStrings;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            titleText,
            style: p15.medium.copyWith(letterSpacing: .3),
          ),
        ),
        kGaps5,
        IField(
          onEditingComplete: onEditingComplete,
          focusNode: focusNode,
          controller: controller,
          hintText: hintText,
          maxLines: 1,
          onlyStrings: onlyStrings,
          readOnly: readOnly,
        ),
        kGaps20,
      ],
    );
  }
}
