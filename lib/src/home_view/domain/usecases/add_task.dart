import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/repo/todo_repo.dart';

class AddTask extends FutureUseCaseWithParams<void, Todo> {
  AddTask({required TodoRepo todoRepo}) : _todoRepo = todoRepo;

  final TodoRepo _todoRepo;

  @override
  ResultFuture<void> call(Todo params) {
    return _todoRepo.addTask(params);
  }
}
