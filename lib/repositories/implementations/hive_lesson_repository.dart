import 'package:collection/collection.dart';
import 'package:dino_run/models/quiz_models/chapter.dart';
import 'package:dino_run/models/quiz_models/choice.dart';
import 'package:dino_run/models/quiz_models/level.dart';
import 'package:dino_run/models/quiz_models/question.dart';
import 'package:dino_run/repositories/lesson_repository.dart';
import 'package:hive/hive.dart';

class HiveLessonRepository implements LessonRepository {
  static const String boxName = 'levels';
  late Box<Level> _box;

  @override
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(LevelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(ChapterAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(QuestionAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(ChoiceAdapter());

    _box = await Hive.openBox<Level>(boxName);
  }

  @override
  Future<void> saveLevels(List<Level> levels) async {
    await _box.clear(); // overwrite old data
    await _box.addAll(levels);
  }

  @override
  Future<List<Level>> getAllLevels() async {
    return _box.values.toList();
  }

  @override
  Future<Level?> getLevel(int levelNumber) async {
    return _box.values.firstWhereOrNull(
      (lvl) => lvl.level == levelNumber,
    );
  }

  @override
  Future<Chapter?> getChapter(int levelNumber, int chapterNumber) async {
    final level = await getLevel(levelNumber);
    if (level == null) return null;

    return level.chapters.firstWhereOrNull(
      (chap) => chap.chapter == chapterNumber,
    );
  }

  @override
  Future<List<Question>> getQuestions(int levelNumber, int chapterNumber) async {
    final chapter = await getChapter(levelNumber, chapterNumber);
    return chapter?.questions ?? [];
  }
}
