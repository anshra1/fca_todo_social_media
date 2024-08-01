// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_selected_setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ViewSelectedSettingAdapter extends TypeAdapter<Setting> {
  @override
  final int typeId = 10;

  @override
  Setting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Setting(
      sortCriteria: fields[0] as SortCriteria,
      colorName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Setting obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.sortCriteria)
      ..writeByte(1)
      ..write(obj.colorName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViewSelectedSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
