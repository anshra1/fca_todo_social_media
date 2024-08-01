// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommonAdapter extends TypeAdapter<Common> {
  @override
  final int typeId = 4;

  @override
  Common read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Common(
      fields[1] as Object,
    );
  }

  @override
  void write(BinaryWriter writer, Common obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
