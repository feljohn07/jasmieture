
import 'package:hive/hive.dart';

part 'bgm.g.dart';

@HiveType(typeId: 13)
enum AudioBgm {
  @HiveField(0)
  bgm('8BitPlatformerLoop.wav'),
  @HiveField(1)
  bgm0('bgm/01.mp3'),
  @HiveField(2)
  mineCraft01('bgm/01.mp3'),
  @HiveField(3)
  mineCraft02('bgm/02.mp3'),
  @HiveField(4)
  mineCraft03('bgm/03.mp3'),
  @HiveField(5)
  mineCraft04('bgm/04.mp3'),
  @HiveField(6)
  retro('bgm/05.mp3'),
  ;

  final String fileName;
  const AudioBgm(this.fileName);
}
