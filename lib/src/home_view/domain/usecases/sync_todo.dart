import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/repo/todo_repo.dart';

class SyncTodo extends FutureUseCaseWithoutParams<void> {
  SyncTodo({required TodoRepo todoRepo}) : _todoRepo = todoRepo;

  final TodoRepo _todoRepo;

  @override
  ResultFuture<void> call() {
    return _todoRepo.sync();
  }
}
