// ignore_for_file: constant_identifier_names

enum TodoType {
  Public('public'),
  Private('private');

  const TodoType(this.value);
  final String value;
}
