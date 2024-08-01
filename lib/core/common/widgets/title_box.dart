import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/res/gap_ex.dart';

class TitleBox extends StatelessWidget {
  const TitleBox({
    required this.titleText,
    required this.text,
    super.key,
  });

  final String titleText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            titleText,
            style: p13.medium.copyWith(letterSpacing: .3),
          ),
        ),
        kGaps3,
        Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade500,
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                text,
                style: p17.semiBold.copyWith(letterSpacing: .3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
