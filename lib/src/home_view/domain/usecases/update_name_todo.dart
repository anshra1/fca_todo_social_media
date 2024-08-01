import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/repo/todo_repo.dart';

class UpdateNameTodo extends FutureUseCaseWithParams<void, UpdateTodoParams> {
  UpdateNameTodo({required TodoRepo todoRepo}) : _todoRepo = todoRepo;

  final TodoRepo _todoRepo;

  @override
  ResultFuture<void> call(UpdateTodoParams params) {
    return _todoRepo.updateNameTodo(
      todoID: params.todoId,
      newTodoName: params.newTodoName,
    );
  }
}

class UpdateTodoParams {
  UpdateTodoParams({
    required this.todoId,
    required this.newTodoName,
  });

  final String todoId;
  final String newTodoName;
}
