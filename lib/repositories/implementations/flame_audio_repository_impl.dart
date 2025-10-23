// import 'package:dino_run/repositories/audio_repository.dart';
// import 'package:flame_audio/flame_audio.dart';

// class FlameAudioRepositoryImpl extends AudioRepository {
//   FlameAudioRepositoryImpl._internal();

//   /// [_instance] represents the single static instance of [FlameAudioRepositoryImpl].
//   static final FlameAudioRepositoryImpl _instance = FlameAudioRepositoryImpl._internal();

//   /// A getter to access the single instance of [FlameAudioRepositoryImpl].
//   static FlameAudioRepositoryImpl get instance => _instance;

//   /// This method is responsible for initializing caching given list of [files],
//   /// and initilizing settings.
//   @override
//   Future<void> initializeAudio() async {
//     List<String> files = [
//       AudioBgm.bgm.fileName,
//       AudioBgm.bgm0.fileName,
//       'sound_effects/hurt7.wav',
//       'sound_effects/jump14.wav',
//       'sound_effects/mouse-click.wav',
//       'sound_effects/swipe-132084.mp3',
//       'sound_effects/drop-coin-384921.mp3',
//     ];

//     // this.settings = settings;
//     FlameAudio.bgm.initialize();
//     // FlameAudio.bgm.play(AudioBgm.bgm.fileName, volume: 0.0);
//     await FlameAudio.audioCache.loadAll(files);
//   }

//   // Starts the given audio file as BGM on loop.
//   @override
//   Future<void> playBgm() async {
//     try {
//       await FlameAudio.bgm.play(AudioBgm.bgm1.fileName, volume: 0.1);
//     } on Exception catch (e) {
//       print('Error on StartBgm(): ${e.toString()}');
//     }
//   }

//   // Pauses currently playing BGM if any.
//   @override
//   Future<void> pauseBgm() async {
//     await FlameAudio.bgm.pause();
//   }

//   // Resumes currently paused BGM if any.
//   @override
//   Future<void> resumeBgm() async {
//     FlameAudio.bgm.resume();
//   }

//   // Stops currently playing BGM if any.
//   @override
//   Future<void> stopBgm() async {
//     await FlameAudio.bgm.stop();
//     // FlameAudio.bgm.play(AudioBgm.bgm.fileName, volume: 0.0);
//   }

//   /// Plays the given audio file once.
//   @override
//   Future<void> playSfx(AudioSfx audio) async {
//     try {
//       await FlameAudio.play(audio.fileName);
//     } on Exception catch (e) {
//       print('Error on playSfx(): ${e.toString()}');
//     }
//   }

//   @override
//   Future<void> playAudio(String audio) async {
//     try {
//       await FlameAudio.play(audio);
//     } on Exception catch (e) {
//       print('Error on playQuestion(): ${e.toString()}');
//     }
//   }
// }
