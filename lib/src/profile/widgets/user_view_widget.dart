import 'package:flutter/material.dart';
import 'package:flutter_learning_go_router/core/common/provider/user_provider.dart';
import 'package:flutter_learning_go_router/core/common/widgets/cached_network_image.dart';
import 'package:flutter_learning_go_router/core/extension/text_style.dart';
import 'package:flutter_learning_go_router/core/res/gap_ex.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, user, w) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Material(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  kGaps10,
                  CacheImage(url: user.user?.photoURL ?? ''),
                  kGaps10,
                  Text(
                    user.user?.name ?? '',
                    style: p18.bold,
                  ),
                  kGaps15,
                  Text(
                    'Date of Birth : ${user.user?.dateOfBirth}',
                    style: p16.medium,
                  ),
                  kGaps5,
                  Text(
                    'Gender : ${user.user?.gender}',
                    style: p16.medium,
                  ),
                  kGaps5,
                  Text(
                    'Library Code : ${user.user?.libraryCode}',
                    style: p16.medium,
                  ),
                  kGaps20,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
