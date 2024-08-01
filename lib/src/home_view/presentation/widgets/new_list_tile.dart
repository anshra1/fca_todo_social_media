import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/res/gap_ex.dart';

class NewListTile extends StatelessWidget {
  const NewListTile({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          children: [
            Icon(Icons.add, size: 22, color: Colors.blue.shade700),
            kGaps5,
            Text(
              'New List',
              style: p15.copyWith(color: Colors.blue.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
