import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/common/widgets/circular_container.dart';
import 'package:flutter_learning_go_router/core/common/widgets/rounded_container.dart';
import 'package:flutter_learning_go_router/core/extension/widget_extension.dart';

class SelectDateWidget extends StatelessWidget {
  const SelectDateWidget({
    required this.onPressed,
    required this.selectedDate,
    super.key,
  });

  final String selectedDate;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      color: Colors.pink.shade500,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            selectedDate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onPressed,
            child: CircularContainer(
              boxShape: BoxShape.circle,
              color: Colors.white,
              child: Icon(
                Icons.close,
                color: Colors.blue.shade800,
                size: 15,
              ).allPadding(3),
            ),
          ),
        ],
      ).allPadding(5),
    );
  }
}
