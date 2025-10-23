// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelAdapter extends TypeAdapter<Level> {
  @override
  final int typeId = 2;

  @override
  Level read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Level(
      level: fields[0] as int,
      chapters: (fields[1] as List).cast<Chapter>(),
      title: fields[2] as String,
      lock: fields[3] as bool,
      difficulty: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Level obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.chapters)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.lock)
      ..writeByte(4)
      ..write(obj.difficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
