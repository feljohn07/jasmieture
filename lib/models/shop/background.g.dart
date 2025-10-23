// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BackgroundAdapter extends TypeAdapter<Background> {
  @override
  final int typeId = 7;

  @override
  Background read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Background(
      name: fields[0] as String,
      parallax: (fields[1] as List).cast<String>(),
      thumbnail: fields[5] as String,
      cost: fields[2] as int,
      purchased: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Background obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.parallax)
      ..writeByte(5)
      ..write(obj.thumbnail)
      ..writeByte(2)
      ..write(obj.cost)
      ..writeByte(3)
      ..write(obj.purchased);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackgroundAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
