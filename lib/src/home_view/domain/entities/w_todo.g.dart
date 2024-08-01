// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'w_todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WhatTodoAdapter extends TypeAdapter<WhatTodo> {
  @override
  final int typeId = 3;

  @override
  WhatTodo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WhatTodo(
      what: fields[1] as String,
      object: fields[2] as Object,
      key: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WhatTodo obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.what)
      ..writeByte(2)
      ..write(obj.object)
      ..writeByte(3)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WhatTodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
