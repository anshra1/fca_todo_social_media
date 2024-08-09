import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';

class Strings {
  Strings._();
  static const verificationId = 'VerificationId';
  static const phoneNumber = 'phoneNumber';

  // User
  static const String name = 'name';
  static const String fatherName = 'fatherName';
  static const String gender = 'gender';
  static const String dateOfBirth = 'dateOfBirth';
  static const String photoURl = 'photoUrl';
  static const String mobileNumber = 'mobileNumber';
  static const String libraryCode = 'libraryCode';
  static const String uid = 'uid';

  // Todos Strings

  static const String todoName = 'todoName';
  static const String date = 'date';
  static const String todoId = 'todoId';
  static const String type = 'type';
  static const String userName = 'userName';
  static const String isImportant = 'Important';
  static const String isCompleted = 'Completed';
  static const String folderName = 'folderName';
  static const String folderId = 'folderId';
  static const String folderIcon = 'folderIcon';
  static const String dueTime = 'dueTime';
  static const String isDeleted = 'isDeleted';
  static const String public = 'Public';
  static const String private = 'Private';
  static const String tasks = 'Tasks';
  static const String tasksId = 'sokdfhj7878dvjn4';

  // hive

  static const String create = 'create';
  static const String delete = 'delete';
  static const String update = 'update';

  // go route
  static const String allFolderview = 'All';
  static const String folder = 'FolderName';
  static const String lastPage = 'lastPages';
  static const String newFolder = 'newFolder';

  static const taskFolder = Folder(
    folderName: Strings.tasks,
    folderId: Strings.tasksId,
    icon: 'NO IMPLEMENTED NOW',
  );
}
