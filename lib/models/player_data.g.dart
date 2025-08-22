// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerDataAdapter extends TypeAdapter<PlayerData> {
  @override
  final int typeId = 0;

  @override
  PlayerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerData()
      ..highScore = fields[1] as int
      ..shopStar = fields[2] as int
      ..headItem = fields[3] as double
      ..eyeItem = fields[4] as double
      ..shirtItem = fields[5] as double;
  }

  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.highScore)
      ..writeByte(2)
      ..write(obj.shopStar)
      ..writeByte(3)
      ..write(obj.headItem)
      ..writeByte(4)
      ..write(obj.eyeItem)
      ..writeByte(5)
      ..write(obj.shirtItem);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
