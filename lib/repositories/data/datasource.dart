// TODO - create single hive datasourece which where we initializes the hive adapters
import 'package:dino_run/models/bgm.dart';
import 'package:dino_run/models/game/player.dart';
import 'package:dino_run/models/game/settings.dart';
import 'package:dino_run/models/game/history.dart';
import 'package:dino_run/models/quiz_models/chapter.dart';
import 'package:dino_run/models/quiz_models/choice.dart';
import 'package:dino_run/models/quiz_models/language.dart';
import 'package:dino_run/models/quiz_models/level.dart';
import 'package:dino_run/models/quiz_models/question.dart';
import 'package:dino_run/models/shop/background.dart';
import 'package:dino_run/models/shop/character.dart';
import 'package:dino_run/models/shop/item.dart';
import 'package:dino_run/models/shop/shop.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/repositories/data/background_data.dart';
import 'package:dino_run/repositories/data/character_data.dart';
import 'package:dino_run/repositories/data/item_data.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Datasource {
  late Box<Language> _languageBox;

  late Box<Level> _levelBox;
  late Box<Chapter> _chapterBox;
  late Box<Question> _questionBox;
  late Box<Choice> _choiceBox;

  late Box<Character> _characterBox;
  late Box<Item> _itemBox;
  late Box<Background> _backgroundBox;
  late Box<Shop> _shopBox;

  late Box<Settings> _settingsBox;
  late Box<Player> _playerBox;
  late Box<History> _historyBox;

  late Box<AudioBgm> _audioBgmBox;

  Box<Language> get languagBox => _languageBox;
  Box<Level> get levelBox => _levelBox;
  Box<Chapter> get chapterBox => _chapterBox;
  Box<Question> get questionBox => _questionBox;
  Box<Choice> get choiceBox => _choiceBox;

  Box<Character> get characterBox => _characterBox;
  Box<Item> get itemBox => _itemBox;
  Box<Background> get backgroundBox => _backgroundBox;
  Box<Shop> get shopBox => _shopBox;

  Box<Settings> get settings => _settingsBox;
  Box<Player> get playerBox => _playerBox;
  Box<History> get historyBox => _historyBox;

  Box<AudioBgm> get audioBgmBox => _audioBgmBox;

  Future<void> initialize() async {
    // For web hive does not need to be initialized.
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init('${dir.path}/lessons/');
    }

    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter<Player>(PlayerAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter<Level>(LevelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter<Chapter>(ChapterAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter<Question>(QuestionAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter<Choice>(ChoiceAdapter());
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter<Item>(ItemAdapter());
    if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter<Background>(BackgroundAdapter());
    if (!Hive.isAdapterRegistered(8)) Hive.registerAdapter<Character>(CharacterAdapter());
    if (!Hive.isAdapterRegistered(9)) Hive.registerAdapter<Shop>(ShopAdapter());
    if (!Hive.isAdapterRegistered(10)) Hive.registerAdapter<Language>(LanguageAdapter());
    if (!Hive.isAdapterRegistered(11)) Hive.registerAdapter<Settings>(SettingsAdapter());
    if (!Hive.isAdapterRegistered(12)) Hive.registerAdapter<History>(HistoryAdapter());
    if (!Hive.isAdapterRegistered(13)) Hive.registerAdapter<AudioBgm>(AudioBgmAdapter());

    _languageBox = await Hive.openBox('language');
    _levelBox = await Hive.openBox<Level>('levels');
    _chapterBox = await Hive.openBox<Chapter>('chapter');
    _questionBox = await Hive.openBox<Question>('question');
    _choiceBox = await Hive.openBox<Choice>('choice');
    _characterBox = await Hive.openBox<Character>('character');
    _itemBox = await Hive.openBox<Item>('item');
    _backgroundBox = await Hive.openBox<Background>('background');
    _shopBox = await Hive.openBox<Shop>('shop');
    _settingsBox = await Hive.openBox('settings');
    _playerBox = await Hive.openBox<Player>('player');
    _historyBox = await Hive.openBox<History>('history');
    _audioBgmBox = await Hive.openBox<AudioBgm>('audiBgm');

    // TODO - clear for now for testing.
    // await _languageBox.clear();
    // await _levelBox.clear();
    // await _chapterBox.clear();
    // await _questionBox.clear();
    // await _choiceBox.clear();
    // await _shopBox.clear();
    // await _characterBox.clear();
    // await _itemBox.clear();
    // await _backgroundBox.clear();
    // await _settingsBox.clear();
    // await _historyBox.clear();

    // initializing data when the app first load, so it will not be empty
    if (_characterBox.isEmpty) {
      await _characterBox.addAll(characterData);
    }
    if (_itemBox.isEmpty) {
      await _itemBox.addAll([...headItemData, ...eyeItemData, ...shirtItemData]);
    }

    if (_backgroundBox.isEmpty) {
      _backgroundBox.addAll(backgroundData);
    }

    if (_settingsBox.isEmpty) {
      await _settingsBox
          .add(Settings(bgm: true, sfx: true, volume: 1, language: 'english', bgmPath: AudioBgm.mineCraft03));
    }
  }
}
