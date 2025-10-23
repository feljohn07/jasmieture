import 'package:dino_run/models/bgm.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:hive/hive.dart';
part 'settings.g.dart';

@HiveType(typeId: 11)
class Settings extends HiveObject {
  @HiveField(0)
  bool bgm;
  @HiveField(1)
  bool sfx;
  @HiveField(2)
  double volume;
  @HiveField(3)
  String language;
  @HiveField(4)
  AudioBgm bgmPath;

  Settings({
    required this.bgm,
    required this.sfx,
    required this.volume,
    required this.language,
    required this.bgmPath,
  });
}
