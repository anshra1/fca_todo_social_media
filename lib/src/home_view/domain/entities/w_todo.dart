import 'package:hive/hive.dart';
part 'w_todo.g.dart';

@HiveType(typeId: 3)
class WhatTodo {
  WhatTodo({
    required this.what,
    required this.object,
    required this.key,
  });

  @HiveField(1)
  final String what;

  @HiveField(2)
  final Object object;

  @HiveField(3)
  final String key;

  @override
  String toString() {
    return 'what $what, object $object, key $key';
  }
}
