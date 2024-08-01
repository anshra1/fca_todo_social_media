import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId: 2)
class Folder extends Equatable {
  const Folder({
    required this.folderId,
    required this.folderName,
    required this.icon,
  });

  const Folder.defaults({
    required String folderId,
    required String folderName,
  }) : this(
          folderId: folderId,
          folderName: folderName,
          icon: 'NO IMPLEMENTED NOW',
        );

  @HiveField(11)
  final String folderId;

  @HiveField(21)
  final String folderName;

  @HiveField(32)
  final String icon;

  @override
  List<Object?> get props => [folderId, folderName];
}
