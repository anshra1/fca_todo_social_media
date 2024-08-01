import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/common/widgets/cached_network_image.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
import 'package:flutter_learning_go_router/core/extension/int_extension.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/res/gap_ex.dart';

class DrawerHead extends StatelessWidget {
  const DrawerHead({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.currentUser?.name.toUpperCase() ?? '';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CacheImage(url: context.currentUser!.photoURL, radius: 30),
        kGaps10,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: p16.bold.copyWith(letterSpacing: .85)),
            2.gap,
            const Text('You are Offline'),
          ],
        ),
      ],
    );
  }
}
