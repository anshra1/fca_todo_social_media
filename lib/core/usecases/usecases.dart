import 'package:flutter_learning_go_router/core/utils/typedef.dart';

abstract class FutureUseCaseWithParams<Type, Params> {
  const FutureUseCaseWithParams();

  ResultFuture<Type> call(Params params);
}

abstract class FutureUseCaseWithoutParams<Type> {
  const FutureUseCaseWithoutParams();

  ResultFuture<Type> call();
}

abstract class StreamUseCaseWithParams<Type, Params> {
  const StreamUseCaseWithParams();

  ResultStream<Type> call(Params params);
}

abstract class StreamUseCaseWithoutParam<Type> {
  const StreamUseCaseWithoutParam();

  ResultStream<Type> call();
}
