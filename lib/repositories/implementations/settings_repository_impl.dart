// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dino_run/models/bgm.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:hive/hive.dart';

import 'package:dino_run/models/game/settings.dart';
import 'package:dino_run/repositories/data/datasource.dart';
import 'package:dino_run/repositories/settings_repository.dart';

class SettingsRepositoryImp extends SettingsRepository {
  final Datasource datasource;
  SettingsRepositoryImp({required this.datasource});

  Box<Settings> get box => datasource.settings;

  // static const boxName = 'settings';
  // late Box<Settings> box;
  // @override
  // Future<void> initialize() async {
  //   if (!Hive.isAdapterRegistered(16)) Hive.registerAdapter(SettingsAdapter());

  //   box = await Hive.openBox(boxName);

  //   if (box.isEmpty) {
  //     await box.add(Settings(
  //       bgm: true,
  //       sfx: true,
  //       volume: 1,
  //       language: 'english',
  //     ));
  //   }
  // }

  @override
  Future<void> setBgm(bool enable) async {
    Settings settings = box.values.first;
    settings.bgm = enable;
    await settings.save();
  }

  @override
  Future<void> setBgmVolumne(double volume) {
    // TODO: implement setBgmVolumne
    throw UnimplementedError();
  }

  @override
  Future<void> setSfx(bool enable) async {
    Settings settings = box.values.first;
    settings.sfx = enable;
    await settings.save();
  }

  @override
  Settings getSettings() {
    return box.values.first;
  }

  @override
  Future<void> setLanguage(String language) async {
    Settings settings = box.values.first;
    settings.language = language;
    await settings.save();
  }

  @override
  Future<void> setBgmPath(AudioBgm path) async {
    Settings settings = box.values.first;
    settings.bgmPath = path;
    await settings.save();
  }
}
