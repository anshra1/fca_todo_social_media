import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/extension/context_extension.dart';
import 'package:flutter_learning_go_router/core/utils/core_utils.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePicImage extends HookWidget {
  const UserProfilePicImage({required this.pickedImageTo, super.key});

  final ValueNotifier<File?> pickedImageTo;

  @override
  Widget build(BuildContext context) {
    final pickedImage = useState<File?>(null);
    return Builder(
      builder: (context) {
        final user = context.currentUser!;
        final userImage = user.photoURL.isEmpty ? null : user.photoURL;

        return CircleAvatar(
          radius: 60,
          backgroundImage: pickedImage.value != null
              ? FileImage(pickedImage.value!)
              : (userImage != null
                  ? NetworkImage(userImage)
                  : const AssetImage('assetName')) as ImageProvider,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(.5),
                ),
              ),
              IconButton(
                onPressed: () async {
                  // ignore: lines_longer_than_80_chars
                  final image = await CoreUtils.pickImage(ImageSource.gallery);
                  if (image != null) {
                    pickedImage.value = image;
                    pickedImageTo.value = image;
                  }
                },
                icon: Icon(
                  // ignore: lines_longer_than_80_chars
                  (pickedImage.value != null || user.photoURL.isNotEmpty)
                      ? Icons.edit
                      : Icons.add_a_photo,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
