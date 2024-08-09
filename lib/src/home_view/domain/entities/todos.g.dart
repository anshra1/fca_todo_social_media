// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 1;

  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo(
      todoName: fields[2] as String,
      date: fields[6] as DateTime,
      todoId: fields[1] as String,
      type: fields[9] as String,
      uid: fields[7] as String,
      userName: fields[8] as String,
      dueTime: fields[11] as String,
      isDelete: fields[10] as bool,
      isImportant: fields[3] as bool,
      isCompleted: fields[5] as bool,
      folderId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.todoId)
      ..writeByte(2)
      ..write(obj.todoName)
      ..writeByte(3)
      ..write(obj.isImportant)
      ..writeByte(4)
      ..write(obj.folderId)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.uid)
      ..writeByte(8)
      ..write(obj.userName)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(10)
      ..write(obj.isDelete)
      ..writeByte(11)
      ..write(obj.dueTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
