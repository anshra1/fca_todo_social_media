import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            context.theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
