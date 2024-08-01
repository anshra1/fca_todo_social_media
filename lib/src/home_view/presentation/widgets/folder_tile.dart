import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
import 'package:flutter_learning_go_router/core/extension/int_extension.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/extension/widget_extension.dart';

class FolderTile extends StatelessWidget {
  const FolderTile({
    required this.title,
    required this.isCollapse,
    required this.onPressed,
    super.key,
  });

  final String title;
  final bool isCollapse;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Ink(
        height: 40,
        width: context.width,
        child: Row(
          children: [
            if (!isCollapse)
              const Icon(
                Icons.keyboard_arrow_right,
                size: 22,
                color: Colors.white,
              )
            else
              const Icon(
                Icons.keyboard_arrow_down,
                size: 22,
                color: Colors.white,
              ),
            3.gap,
            Text(
              title,
              style: p18.white,
            ),
          ],
        ),
      ).leftPadding(10),
    );
  }
}
