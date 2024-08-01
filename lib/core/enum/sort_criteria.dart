//enum SortCriteria { creationDate, alphabetical, important, dueDate, none }

import 'package:hive/hive.dart';

part 'sort_criteria.g.dart';

@HiveType(typeId: 6) // Choose a unique typeId
enum SortCriteria {
  @HiveField(0)
  none,

  @HiveField(1)
  important,

  @HiveField(2)
  dueDate,

  @HiveField(3)
  alphabetical,

  @HiveField(4)
  creationDate;
}

extension SortCriteriaExtension on SortCriteria {
  String toDisplayString() {
    switch (this) {
      case SortCriteria.none:
        return 'None';
      case SortCriteria.important:
        return 'Important';
      case SortCriteria.dueDate:
        return 'Due Date';
      case SortCriteria.alphabetical:
        return 'Alphabetical';
      case SortCriteria.creationDate:
        return 'Creation Date';
    }
  }
}
