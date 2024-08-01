import 'package:flutter_learning_go_router/core/usecases/usecases.dart';
import 'package:flutter_learning_go_router/core/utils/typedef.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/repo/todo_repo.dart';

class StreamError extends StreamUseCaseWithoutParam<Exception> {
  StreamError(this._todoRepo);
  final TodoRepo _todoRepo;

  @override
  ResultStream<Exception> call() {
    return _todoRepo.streamError();
  }
}
