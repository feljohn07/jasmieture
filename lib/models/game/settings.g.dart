// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 11;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      bgm: fields[0] as bool,
      sfx: fields[1] as bool,
      volume: fields[2] as double,
      language: fields[3] as String,
      bgmPath: fields[4] as AudioBgm,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.bgm)
      ..writeByte(1)
      ..write(obj.sfx)
      ..writeByte(2)
      ..write(obj.volume)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.bgmPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
