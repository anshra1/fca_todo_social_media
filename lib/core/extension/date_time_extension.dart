import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String get formattedDate {
    return '$day/$month/$year';
  }

  String toDueDateString() {
    final formatter = DateFormat('EEE, d MMM');
    return 'Due ${formatter.format(this)}';
  }


  DateTime fromDueDateString(String dueDateString) {
    final formatter = DateFormat('Due EEE, d MMM');
    final dateString = dueDateString.replaceFirst('Due ', '');
    return formatter.parse(dateString);
  }

}
