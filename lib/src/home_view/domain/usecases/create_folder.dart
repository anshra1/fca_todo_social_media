import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/repo/todo_repo.dart';

class CreateFolder extends FutureUseCaseWithParams<void, Folder> {
  CreateFolder({required TodoRepo todoRepo}) : _todoRepo = todoRepo;

  final TodoRepo _todoRepo;

  @override
  ResultFuture<void> call(Folder params) {
    return _todoRepo.createFolders(params);
  }
}
