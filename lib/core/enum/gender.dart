// ignore_for_file: constant_identifier_names

enum Gender {
  Male(value: 'Male'),
  Female(value: 'Female'),
  None(value: 'None');

  const Gender({required this.value});

  final String value;
}
