import 'package:equatable/equatable.dart';
import 'package:flutter_learning_go_router/core/error/exception.dart';

abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    required this.statusCode,
  }) : assert(
          statusCode is int || statusCode is String,
          'statusCode must be of type int or String',
        );
  final String message;
  final dynamic statusCode;

  String get errorMessage {
    final stausText =
        statusCode is! String || int.tryParse(statusCode as String) != null;

    return '$statusCode ${stausText ? 'Error' : ''} $message';
  }

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    required super.statusCode,
  });

  CacheFailure.fromException(
    CacheException cacheException, {
    String? userMessage,
  }) : this(
          message: '${cacheException.message} ${userMessage ?? ''}',
          statusCode: cacheException.statusCode,
        );

  @override
  String toString() =>
      'CacheFailue(message: $message, statusCode: $statusCode)';
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    required super.statusCode,
  });

  ServerFailure.fromException(
    ServerException serverException,
  ) : this(
          message: serverException.message,
          statusCode: serverException.statusCode,
        );

  @override
  String toString() =>
      'ServerFailure(message: $message, statusCode: $statusCode)';
}
