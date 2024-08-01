import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        try {
          context.pop();
        } catch (_) {
          Navigator.of(context).pop();
        }
      },
      icon: Theme.of(context).platform == TargetPlatform.iOS
          ? const Icon(Icons.arrow_back_ios_new)
          : const Icon(Icons.arrow_back),
    );
  }
}
