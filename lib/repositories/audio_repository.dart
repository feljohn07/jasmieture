import 'package:dino_run/models/bgm.dart';
import 'package:hive/hive.dart';

abstract class AudioRepository {
  Future<void> initializeAudio();

  Future<void> playBgm(AudioBgm bgm);
  Future<void> stopBgm();
  Future<void> pauseBgm();
  Future<void> resumeBgm();

  Future<void> playAudio(String path);
  Future<void> playSfx(AudioSfx audioSfx);

  Future<void> startSequentialPlaylist(List<String> paths);
  Future<void> stopSequentialPlaylist();
  void dispose();
}

// Define the enum with a property for the file name
enum AudioSfx {
  hurt('sound_effects/game-start.mp3'),
  popQuestion('sound_effects/game-start.mp3'),
  jump('sound_effects/jump14.wav'),

  click('sound_effects/mouse-click.wav'),
  swipe('sound_effects/swipe-132084.mp3'),
  katching('sound_effects/drop-coin-384921.mp3'),

  clapping(''),
  wrongAnswer('sound_effects/error.mp3'),
  correctAnswer('sound_effects/correct-6033.mp3'),

  gameCompleted('sound_effects/game-level-complete.mp3'),
  gameOver('sound_effects/game-over-arcade.mp3');

  // Each enum value will have a final 'fileName' property
  final String fileName;
  const AudioSfx(this.fileName);
}
