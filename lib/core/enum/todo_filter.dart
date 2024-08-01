import 'package:flutter_learning_go_router/core/strings/strings.dart';

enum TodoFilter {
  important(Strings.isImportant),
  completed(Strings.isCompleted),
  folder('folder');

  const TodoFilter(this.value);
  final String value;
}
