import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_learning_go_router/core/strings/link.dart';
import 'package:flutter_learning_go_router/core/utils/core_utils.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends HookWidget {
  const UserImage({
    required this.pickedImageFile,
    super.key,
  });

  final ValueNotifier<File?> pickedImageFile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListenableBuilder(
        listenable: pickedImageFile,
        builder: (BuildContext context, Widget? child) {
          return CircleAvatar(
            radius: 65,
            backgroundImage: pickedImageFile.value != null
                ? FileImage(pickedImageFile.value!)
                : (kAvtar.isNotEmpty && Uri.parse(kAvtar).isAbsolute)
                    ? const NetworkImage(kAvtar) as ImageProvider
                    : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 1,
                  right: -7,
                  child: IconButton(
                    onPressed: () async {
                      final image =
                          await CoreUtils.pickImage(ImageSource.gallery);
                      if (image != null) {
                        pickedImageFile.value = image;
                      }
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
