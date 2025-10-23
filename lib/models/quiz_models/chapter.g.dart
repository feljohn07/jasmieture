// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChapterAdapter extends TypeAdapter<Chapter> {
  @override
  final int typeId = 3;

  @override
  Chapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chapter(
      chapter: fields[0] as int,
      questions: (fields[1] as List).cast<Question>(),
      title: fields[2] as String,
      lock: fields[3] as bool,
      highScore: fields[4] as int,
      timeTakenInSeconds: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Chapter obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.chapter)
      ..writeByte(1)
      ..write(obj.questions)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.lock)
      ..writeByte(4)
      ..write(obj.highScore)
      ..writeByte(5)
      ..write(obj.timeTakenInSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
