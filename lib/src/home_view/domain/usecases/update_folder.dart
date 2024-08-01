import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/repo/todo_repo.dart';

class UpdateFolder extends FutureUseCaseWithParams<void, UpdateFolderParams> {
  UpdateFolder({required TodoRepo todoRepo}) : _todoRepo = todoRepo;

  final TodoRepo _todoRepo;

  @override
  ResultFuture<void> call(UpdateFolderParams params) {
    return _todoRepo.updateNameTodo(
      todoID: params.folderId,
      newTodoName: params.newFolderName,
    );
  }
}

class UpdateFolderParams {
  UpdateFolderParams({
    required this.folderId,
    required this.newFolderName,
  });

  final String folderId;
  final String newFolderName;
}
