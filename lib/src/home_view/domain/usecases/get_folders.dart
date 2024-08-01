import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/folder.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/repo/todo_repo.dart';

class GetFolders extends FutureUseCaseWithoutParams<List<Folder>> {
  GetFolders({required TodoRepo todoRepo}) : _todoRepo = todoRepo;

  final TodoRepo _todoRepo;

  @override
  ResultFuture<List<Folder>> call() {
    return _todoRepo.getFolders();
  }
}
