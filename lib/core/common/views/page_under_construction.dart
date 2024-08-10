import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/src/auth/presentation/import.dart';
import 'package:go_router/go_router.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              context.go(PhoneNumberView.routeName);
            },
            child: const Text(
              'Page Under contruction',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
