import 'package:dino_run/models/quiz_models/chapter.dart';
import 'package:dino_run/models/quiz_models/level.dart';
import 'package:dino_run/models/quiz_models/question.dart';

abstract class LessonRepository {
  Future<void> init();
  Future<void> saveLevels(List<Level> levels);
  Future<List<Level>> getAllLevels();
  Future<Level?> getLevel(int level);
  Future<List<Chapter>> getChapters(int level);
  Future<List<Question>> getQuestions(int level, int chapter);
}
