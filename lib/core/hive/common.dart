import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'common.g.dart';

@HiveType(typeId: 4)
class Common extends Equatable {
  const Common(this.value);

  @HiveField(1)
  final Object value;

  @override
  List<Object> get props => [value];
}
