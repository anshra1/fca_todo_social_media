import 'package:flutter_learning_go_router/core/enum/sort_criteria.dart';
import 'package:flutter_learning_go_router/src/home_view/domain/entities/todos.dart';

extension SortTodoListExtension on List<Todo> {
  List<Todo> sortByCriteria(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.creationDate:
        return this..sort((a, b) => a.date.compareTo(b.date));
      case SortCriteria.alphabetical:
        return this..sort((a, b) => a.todoName.compareTo(b.todoName));
      case SortCriteria.important:
        return this..sort((a, b) => b.isImportant ? 1 : -1);
      case SortCriteria.dueDate:
        return this..sort((a, b) => a.dueTime.compareTo(b.dueTime));
      case SortCriteria.none:
        return this;
    }
  }

  List<Todo> reverseSortByCriteria(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.creationDate:
        return this..sort((a, b) => b.date.compareTo(a.date));
      case SortCriteria.alphabetical:
        return this..sort((a, b) => a.todoName.compareTo(b.todoName));
      case SortCriteria.important:
        return this..sort((a, b) => a.isImportant ? 1 : -1);
      case SortCriteria.dueDate:
        return this..sort((a, b) => b.dueTime.compareTo(a.dueTime));
      case SortCriteria.none:
        return this;
    }
  }
}
