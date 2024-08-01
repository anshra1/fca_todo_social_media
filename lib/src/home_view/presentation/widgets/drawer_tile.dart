import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/extension/int_extension.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.listLength,
    super.key,
  });

  final Icon icon;
  final String title;
  final VoidCallback onTap;
  final int? listLength;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              icon,
              14.gap,
              Text(
                title,
                style: p16.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (listLength != null)
                Text(
                  listLength.toString(),
                  style: p16.copyWith(color: Colors.black87),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
