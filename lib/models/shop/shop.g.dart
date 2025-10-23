// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopAdapter extends TypeAdapter<Shop> {
  @override
  final int typeId = 9;

  @override
  Shop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Shop(
      star: fields[0] as int,
      characterSelected: fields[1] as Character,
      headItemSelected: fields[2] as Item,
      eyeItemSelected: fields[3] as Item,
      shirtItemSelected: fields[4] as Item,
      backgroundSelected: fields[5] as Background,
    );
  }

  @override
  void write(BinaryWriter writer, Shop obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.star)
      ..writeByte(1)
      ..write(obj.characterSelected)
      ..writeByte(2)
      ..write(obj.headItemSelected)
      ..writeByte(3)
      ..write(obj.eyeItemSelected)
      ..writeByte(4)
      ..write(obj.shirtItemSelected)
      ..writeByte(5)
      ..write(obj.backgroundSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
