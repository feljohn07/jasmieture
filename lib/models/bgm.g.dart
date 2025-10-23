// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bgm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioBgmAdapter extends TypeAdapter<AudioBgm> {
  @override
  final int typeId = 13;

  @override
  AudioBgm read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AudioBgm.bgm;
      case 1:
        return AudioBgm.bgm0;
      case 2:
        return AudioBgm.mineCraft01;
      case 3:
        return AudioBgm.mineCraft02;
      case 4:
        return AudioBgm.mineCraft03;
      case 5:
        return AudioBgm.mineCraft04;
      case 6:
        return AudioBgm.retro;
      default:
        return AudioBgm.bgm;
    }
  }

  @override
  void write(BinaryWriter writer, AudioBgm obj) {
    switch (obj) {
      case AudioBgm.bgm:
        writer.writeByte(0);
        break;
      case AudioBgm.bgm0:
        writer.writeByte(1);
        break;
      case AudioBgm.mineCraft01:
        writer.writeByte(2);
        break;
      case AudioBgm.mineCraft02:
        writer.writeByte(3);
        break;
      case AudioBgm.mineCraft03:
        writer.writeByte(4);
        break;
      case AudioBgm.mineCraft04:
        writer.writeByte(5);
        break;
      case AudioBgm.retro:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioBgmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
