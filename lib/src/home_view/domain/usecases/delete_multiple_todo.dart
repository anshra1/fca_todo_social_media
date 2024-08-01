import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/repo/todo_repo.dart';

class DeleteMultipleTodo extends FutureUseCaseWithParams<void, List<Todo>> {
  DeleteMultipleTodo({required TodoRepo todoRepo}) : _todoRepo = todoRepo;

  final TodoRepo _todoRepo;

  @override
  ResultFuture<void> call(List<Todo> params) {
    return _todoRepo.deleteMultipleTodo(params);
  }
}
