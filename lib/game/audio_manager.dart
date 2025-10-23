import 'package:dino_run/models/bgm.dart';
import 'package:dino_run/repositories/audio_repository.dart';

import '/models/settings.dart';

class AudioManager {
  late AudioRepository audioRepository;
  late SettingsData settings;

  AudioManager._internal();

  static final AudioManager _instance = AudioManager._internal();

  static AudioManager get instance => _instance;

  Future<void> init(SettingsData settings, AudioRepository audioRepository) async {
    this.settings = settings;
    this.audioRepository = audioRepository;

    await this.audioRepository.initializeAudio();
  }

  // Starts the given audio file as BGM on loop.
  void startBgm(AudioBgm bgm) async {
    if (settings.bgm) {
      audioRepository.playBgm(bgm);
    }
  }

  // Pauses currently playing BGM if any.
  void pauseBgm() {
    if (settings.bgm) {
      audioRepository.pauseBgm();
    }
  }

  // Resumes currently paused BGM if any.
  void resumeBgm() {
    if (settings.bgm) {
      audioRepository.resumeBgm();
    }
  }

  // Stops currently playing BGM if any.
  void stopBgm() {
    audioRepository.stopBgm();
  }

  /// Plays the given audio file once.
  void playSfx(AudioSfx audio) async {
    // print('playSfx() = $audio');
    if (settings.sfx) {
      await audioRepository.playSfx(audio);
    }
  }

  Future<void> playQuestion(String audio) async {
    try {
      await audioRepository.playAudio(audio);
    } on Exception catch (e) {
      print('Error on playQuestion(): ${e.toString()}');
    }
  }
}

// import 'package:dino_run/repositories/audio_repository.dart';

// import '/models/settings.dart';
// import 'package:flame/flame.dart';
// import 'package:flame_audio/flame_audio.dart';

// import 'package:dino_run/game/dino_run.dart';

// /// This class is the common interface between [DinoRun]
// /// and [Flame] engine's audio APIs.
// class AudioManager {
//   // AudioRepository audioRepository = AudioRepository();

//   late Settings settings;
//   AudioManager._internal();

//   /// [_instance] represents the single static instance of [AudioManager].
//   static final AudioManager _instance = AudioManager._internal();

//   /// A getter to access the single instance of [AudioManager].
//   static AudioManager get instance => _instance;

//   /// This method is responsible for initializing caching given list of [files],
//   /// and initilizing settings.
//   Future<void> init(Settings settings) async {
//     List<String> files = [
//       AudioBgm.bgm.fileName,
//       AudioBgm.bgm0.fileName,
//       'sound_effects/hurt7.wav',
//       'sound_effects/jump14.wav',
//       'sound_effects/mouse-click.wav',
//       'sound_effects/swipe-132084.mp3',
//       'sound_effects/drop-coin-384921.mp3',
//     ];

//     this.settings = settings;
//     FlameAudio.bgm.initialize();
//     FlameAudio.bgm.play(AudioBgm.bgm.fileName, volume: 0.0);
//     await FlameAudio.audioCache.loadAll(files);
//   }

//   // Starts the given audio file as BGM on loop.
//   void startBgm(String? fileName) async {
//     if (settings.bgm) {
//       try {
//         await FlameAudio.bgm.play(AudioBgm.bgm1.fileName, volume: 0.1);
//       } on Exception catch (e) {
//         print('Error on StartBgm(): ${e.toString()}');
//       }
//     }
//   }

//   // Pauses currently playing BGM if any.
//   void pauseBgm() {
//     if (settings.bgm) {
//       FlameAudio.bgm.pause();
//     }
//   }

//   // Resumes currently paused BGM if any.
//   void resumeBgm() {
//     if (settings.bgm) {
//       FlameAudio.bgm.resume();
//     }
//   }

//   // Stops currently playing BGM if any.
//   void stopBgm() {
//     FlameAudio.bgm.stop();
//     FlameAudio.bgm.play(AudioBgm.bgm.fileName, volume: 0.0);
//   }

//   /// Plays the given audio file once.
//   void playSfx(AudioSfx audio) async {
//     // print('playSfx() = $audio');
//     if (settings.sfx) {
//       try {
//         await FlameAudio.play(audio.fileName);
//       } on Exception catch (e) {
//         print('Error on playSfx(): ${e.toString()}');
//       }
//     }
//   }

//   void playQuestion(String audio) async {
//     try {
//       await FlameAudio.play(audio);
//     } on Exception catch (e) {
//       print('Error on playQuestion(): ${e.toString()}');
//     }
//   }
// }
