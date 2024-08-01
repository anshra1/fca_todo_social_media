// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
import 'package:flutter_learning_go_router/core/extension/int_extension.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/extension/widget_extension.dart';

class SortedTileTitle extends StatelessWidget {
  const SortedTileTitle({
    required this.title,
    required this.isCollapse,
    required this.reverseSortCriteria,
    required this.closeSorting,
    super.key,
  });

  final String title;
  final bool isCollapse;
  final VoidCallback reverseSortCriteria;
  final VoidCallback closeSorting;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: reverseSortCriteria,
      child: Ink(
        height: 40,
        width: context.width,
        child: Row(
          children: [
            if (!isCollapse)
              const Icon(Icons.keyboard_arrow_up, size: 22, color: Colors.white)
            else
              const Icon(Icons.keyboard_arrow_down,
                  size: 22, color: Colors.white),
            3.gap,
            Text(
              title,
              style: p18.white,
            ),
            const Spacer(),
            GestureDetector(
              onTap: closeSorting,
              child: const Icon(Icons.close, color: Colors.white, size: 22),
            ),
            18.gap,
          ],
        ),
      ).leftPadding(10),
    );
  }
}
