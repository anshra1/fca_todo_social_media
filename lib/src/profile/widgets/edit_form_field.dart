import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/common/widgets/title_text_field.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';

class EditFormField extends StatelessWidget {
  const EditFormField({
    required this.fullNameController,
    required this.fatherNameController,
    required this.genderController,
    required this.dateOfBirthController,
    super.key,
  });

  final TextEditingController fullNameController;
  final TextEditingController fatherNameController;
  final TextEditingController genderController;
  final TextEditingController dateOfBirthController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditTitleTextField(
          controller: fullNameController,
          hintText: context.currentUser?.name ?? '',
          titleText: 'Full Name',
        ),
        EditTitleTextField(
          controller: fatherNameController,
          hintText: context.currentUser?.fatherName ?? '',
          titleText: 'Father Name',
        ),
        EditTitleTextField(
          controller: genderController,
          hintText: context.currentUser?.gender ?? '',
          titleText: 'Gender',
        ),
        EditTitleTextField(
          controller: dateOfBirthController,
          titleText: 'Date Of Birth',
          hintText: context.currentUser?.dateOfBirth ?? '',
        ),
      ],
    );
  }
}
