import 'package:flutter_learning_go_router/core/strings/strings.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';

class FolderModel extends Folder {
  const FolderModel({
    required super.folderId,
    required super.folderName,
    required super.icon,
  });

  factory FolderModel.fromMap(Map<String, dynamic> map) {
    return FolderModel(
      folderId: map[Strings.folderId] as String,
      folderName: map[Strings.folderName] as String,
      icon: map[Strings.folderIcon] as String,
    );
  }

  factory FolderModel.fromFolder(Folder folder) {
    return FolderModel(
      folderId: folder.folderId,
      folderName: folder.folderName,
      icon: folder.icon,
    );
  }

  const FolderModel.empty()
      : super(
          folderId: 'folderId',
          folderName: 'folderName',
          icon: 'icon',
        );

  FolderModel copyWith({
    String? folderId,
    String? folderName,
    String? icon,
  }) {
    return FolderModel(
      folderId: folderId ?? this.folderId,
      folderName: folderName ?? this.folderName,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Strings.folderId: folderId,
      Strings.folderName: folderName,
      Strings.folderIcon: icon,
    };
  }

  @override
  String toString() =>
      'FolderModel(folderId: $folderId, folderName: $folderName, icon: $icon)';
}
