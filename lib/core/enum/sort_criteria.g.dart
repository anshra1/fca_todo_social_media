// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sort_criteria.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SortCriteriaAdapter extends TypeAdapter<SortCriteria> {
  @override
  final int typeId = 6;

  @override
  SortCriteria read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SortCriteria.none;
      case 1:
        return SortCriteria.important;
      case 2:
        return SortCriteria.dueDate;
      case 3:
        return SortCriteria.alphabetical;
      case 4:
        return SortCriteria.creationDate;
      default:
        return SortCriteria.none;
    }
  }

  @override
  void write(BinaryWriter writer, SortCriteria obj) {
    switch (obj) {
      case SortCriteria.none:
        writer.writeByte(0);

      case SortCriteria.important:
        writer.writeByte(1);

      case SortCriteria.dueDate:
        writer.writeByte(2);

      case SortCriteria.alphabetical:
        writer.writeByte(3);

      case SortCriteria.creationDate:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortCriteriaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
