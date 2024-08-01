import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/enum/gender.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/res/gap_ex.dart';

class GenderButton extends HookWidget {
  const GenderButton({required this.gender, super.key});

  final ValueNotifier<Gender> gender;

  @override
  Widget build(BuildContext context) {
    final gen = useState<Gender>(Gender.None);

    return SizedBox(
      height: 45,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                gen.value = Gender.Male;
                gender.value = Gender.Male;
              },
              child: Ink(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: gen.value == Gender.Male
                        ? Colors.blue.shade300
                        : Colors.grey.shade400,
                  ),
                  child: Center(
                    child: Text(
                      'Male',
                      style: p16.medium.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          kGaps20,
          Expanded(
            child: InkWell(
              onTap: () {
                gen.value = Gender.Female;
                gender.value = Gender.Female;
              },
              child: Ink(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: gen.value == Gender.Female
                        ? Colors.pink.shade300
                        : Colors.grey.shade400,
                  ),
                  child: Center(
                    child: Text(
                      'Female',
                      style: p16.medium.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
