import 'package:collection/collection.dart';
import 'package:dino_run/models/quiz_models/chapter.dart';
import 'package:dino_run/models/quiz_models/language.dart';
import 'package:dino_run/models/quiz_models/level.dart';
import 'package:dino_run/models/quiz_models/question.dart';
import 'package:dino_run/repositories/data/datasource.dart';
import 'package:dino_run/repositories/lesson_repository.dart';
import 'package:hive/hive.dart';

class LessonRepositoryImpl implements LessonRepository {
  final Datasource datasource;

  LessonRepositoryImpl({required this.datasource});

  Box<Language> get _languageBox => datasource.languagBox;
  // Box<Level> get _levelBox => datasource.levelBox;
  // Box<Chapter> get _chapterBox => datasource.chapterBox;
  // Box<Question> get _questionBox => datasource.questionBox;
  // Box<Choice> get _choiceBox => datasource.choiceBox;

  // late Box<Language> _languageBox;
  // late Box<Level> _levelBox;
  // late Box<Chapter> _chapterBox;
  // late Box<Question> _questionBox;
  // late Box<Choice> _choiceBox;

  // @override
  // Future<void> init() async {
  //   if (!Hive.isAdapterRegistered(10)) Hive.registerAdapter(LanguageAdapter());
  //   if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(LevelAdapter());
  //   if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(ChapterAdapter());
  //   if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(QuestionAdapter());
  //   if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(ChoiceAdapter());

  //   _languageBox = await Hive.openBox('language');
  //   _levelBox = await Hive.openBox<Level>('levels');
  //   _chapterBox = await Hive.openBox<Chapter>('chapter');
  //   _questionBox = await Hive.openBox<Question>('question');
  //   _choiceBox = await Hive.openBox<Choice>('choice');

  //   await _languageBox.clear();
  //   await _levelBox.clear();
  //   await _chapterBox.clear();
  //   await _questionBox.clear();
  //   await _choiceBox.clear();
  // }

  @override
  Future<void> saveLevels(String language, List<Level> levels) async {
    switch (language) {
      case 'english':
        // checks if the language 'english' is already populated
        if (_languageBox.isNotEmpty &&
            _languageBox.values.where((element) => element.language == 'english').isNotEmpty) {
          return;
        }
        await _languageBox.add(Language(language: 'english', levels: levels));
        break;
      case 'cebuano':
        if (_languageBox.isNotEmpty &&
            _languageBox.values.where((element) => element.language == 'cebuano').isNotEmpty) {
          return;
        }
        await _languageBox.add(Language(language: 'cebuano', levels: levels));
        break;
      default:
    }
  }

  @override
  List<Level> getAllLevels(String language) {
    final languageResult = _languageBox.values.firstWhere((element) => element.language == language);
    return languageResult.levels.toList();
  }

  @override
  Level? getLevel(String language, int levelNumber) {
    return _languageBox.values.firstWhere((element) => element.language == language).levels.firstWhereOrNull(
          (lvl) => lvl.level == levelNumber,
        );
  }

  @override
  List<Chapter> getChapters(String language, int levelNumber) {
    final level = getLevel(language, levelNumber);
    if (level == null) return [];

    return level.chapters;
  }

  @override
  List<Question> getQuestions(String language, int levelNumber, int chapterNumber) {
    final chapter = _getChapter(language, levelNumber, chapterNumber);
    return chapter?.questions ?? [];
  }

  Chapter? _getChapter(String language, int levelNumber, int chapterNumber) {
    final level = getLevel(language, levelNumber);
    if (level == null) return null;

    return level.chapters.firstWhereOrNull(
      (chap) => chap.chapter == chapterNumber,
    );
  }

  @override
  void unlockChapter(Chapter chapter) {
    chapter.lock = false;
    chapter.save();
  }

  @override
  void unlockLevel(Level level) {
    level.lock = false;
    level.save();
  }
}
