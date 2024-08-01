import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/common/widgets/i_field.dart';
import 'package:flutter_learning_go_router/core/extension/date_time_extension.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/res/gap_ex.dart';
import 'package:flutter_learning_go_router/core/utils/core_utils.dart';

class DateOfBirth extends HookWidget {
  const DateOfBirth({required this.dateOfBirth, super.key});

  final ValueNotifier<String?> dateOfBirth;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Text(
              'Select Date of Birth',
              style: p15.medium.copyWith(letterSpacing: .3),
            ),
          ),
          kGaps5,
          IField(
            controller: controller,
            readOnly: true,
            suffixIcon: GestureDetector(
              onTap: () async {
                // ignore: lines_longer_than_80_chars
                final date = await CoreUtils.pickDate(context) ?? DateTime.now();

                controller.text = date.formattedDate;
                dateOfBirth.value = date.formattedDate;
              },
              child: const Icon(Icons.calendar_month_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
