import 'package:flutter/material.dart';

class PublicView extends StatelessWidget {
  const PublicView({super.key});

  static const routeName = '/public-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {},
          child: const Text('Home View'),
        ),
      ),
    );
  }
}
