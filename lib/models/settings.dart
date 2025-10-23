import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/models/bgm.dart';
import 'package:dino_run/models/game/settings.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/repositories/settings_repository.dart';
import 'package:flutter/foundation.dart';

class SettingsData extends ChangeNotifier {
  SettingsRepository settingsRepository;
  late Settings settings;

  SettingsData(this.settingsRepository) {
    settings = settingsRepository.getSettings();
  }

  AudioBgm get bgmPath => settings.bgmPath;
  Future<void> setBgmPath(AudioBgm path) async {
    await settingsRepository.setBgmPath(path);
    AudioManager.instance.startBgm(path);

    notifyListeners();
  }

  bool get bgm => settings.bgm;
  Future<void> setBgm(bool value) async {
    await settingsRepository.setBgm(value);
    settings = settingsRepository.getSettings();
    notifyListeners();
  }

  bool get sfx => settings.sfx;
  Future<void> setSfx(bool value) async {
    await settingsRepository.setSfx(value);
    settings = settingsRepository.getSettings();
    notifyListeners();
  }
}
