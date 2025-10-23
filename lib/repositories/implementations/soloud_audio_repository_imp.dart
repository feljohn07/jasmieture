import 'dart:async';

import 'package:dino_run/models/bgm.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:dino_run/repositories/audio_repository.dart';

class SoloudAudioRepositoryImp extends AudioRepository {
  late SoLoud _soloud;

  SoundHandle? musicHandle;
  SoundHandle? questionHandle;

  // --- Playlist State ---
  List<String> _playlist = [];
  int _playlistIndex = -1;
  SoundHandle? _playlistHandle;
  Timer? _pollingTimer;
  // --------------------

  @override
  Future<void> initializeAudio() async {
    _soloud = SoLoud.instance;
    await _soloud.init();
  }

  @override
  Future<void> playBgm(AudioBgm bgm) async {
    if (musicHandle != null) {
      if (_soloud.getIsValidVoiceHandle(musicHandle!)) {
        await _soloud.stop(musicHandle!);
      }
    }

    final bgmSource = await _soloud.loadAsset(
      'assets/audio/${bgm.fileName}',
      mode: LoadMode.disk,
    );

    musicHandle = await _soloud.play(bgmSource, looping: true, volume: 0.5);
  }

  @override
  Future<void> pauseBgm() async {
    if (musicHandle == null) return;
    if (!_soloud.getPause(musicHandle!)) _soloud.pauseSwitch(musicHandle!);
  }

  @override
  Future<void> playSfx(AudioSfx sfx) async {
    final source = await _soloud.loadAsset('assets/audio/${sfx.fileName}');
    final sfxHandle = await _soloud.play(source);
  }

  @override
  Future<void> playAudio(String path) async {
    final source = await _soloud.loadAsset(path);
    questionHandle = await _soloud.play(source);
  }

  @override
  Future<void> resumeBgm() async {
    if (musicHandle == null) return;
    if (_soloud.getPause(musicHandle!)) _soloud.pauseSwitch(musicHandle!);
  }

  @override
  Future<void> stopBgm() async {
    if (musicHandle == null) return;
    _soloud.stop(musicHandle!);
  }

  @override
  Future<void> startSequentialPlaylist(List<String> paths) async {
    if (paths.isEmpty) return;

    // Stop any previously running playlist to start fresh
    await stopSequentialPlaylist();

    _playlist = paths;
    _playlistIndex = -1; // Start at -1 so the first call to _playNext starts at 0
    await _playNextInPlaylist();

    print(paths);
  }

  @override
  Future<void> stopSequentialPlaylist() async {
    _pollingTimer?.cancel();
    if (_playlistHandle != null && _soloud.getIsValidVoiceHandle(_playlistHandle!)) {
      await _soloud.stop(_playlistHandle!);
    }
    _playlistHandle = null;
    _playlistIndex = -1;
    _playlist.clear();
  }

  /// Private helper to play the next track in the sequence.
  Future<void> _playNextInPlaylist() async {
    if (_playlist.isEmpty) return;

    // Loop to the beginning of the playlist
    _playlistIndex = (_playlistIndex + 1) % _playlist.length;
    final audioPath = _playlist[_playlistIndex];

    final source = await _soloud.loadAsset(audioPath);
    _playlistHandle = await _soloud.play(source);

    // Start polling to know when this track finishes
    _startPollingForPlaylist();
  }

  /// Private helper to check when a track is done.
  void _startPollingForPlaylist() {
    _pollingTimer?.cancel(); // Ensure only one timer is active
    _pollingTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      // If the handle is invalid (sound finished) or null, play the next one
      if (_playlistHandle == null || !_soloud.getIsValidVoiceHandle(_playlistHandle!)) {
        timer.cancel();
        _playNextInPlaylist();
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _soloud.deinit(); // Properly dispose of the SoLoud instance
  }
}
