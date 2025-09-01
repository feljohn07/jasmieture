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
      ..shirtItem = fields[5] as double
      ..character = fields[6] as String
      ..firstName = fields[7] as String
      ..middleName = fields[8] as String
      ..lastName = fields[9] as String
      ..age = fields[10] as String
      ..section = fields[11] as String;
  }

  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.highScore)
      ..writeByte(2)
      ..write(obj.shopStar)
      ..writeByte(3)
      ..write(obj.headItem)
      ..writeByte(4)
      ..write(obj.eyeItem)
      ..writeByte(5)
      ..write(obj.shirtItem)
      ..writeByte(6)
      ..write(obj.character)
      ..writeByte(7)
      ..write(obj.firstName)
      ..writeByte(8)
      ..write(obj.middleName)
      ..writeByte(9)
      ..write(obj.lastName)
      ..writeByte(10)
      ..write(obj.age)
      ..writeByte(11)
      ..write(obj.section);
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
