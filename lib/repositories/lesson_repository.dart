import 'package:dino_run/models/quiz_models/chapter.dart';
import 'package:dino_run/models/quiz_models/level.dart';
import 'package:dino_run/models/quiz_models/question.dart';

abstract class LessonRepository {
  // Future<void> init();
  Future<void> saveLevels(String language, List<Level> levels);
  List<Level> getAllLevels(String language);
  Level? getLevel(String language, int level);
  List<Chapter> getChapters(String language, int level);
  List<Question> getQuestions(String language, int level, int chapter);

  void unlockLevel(Level level);
  void unlockChapter(Chapter chapter);
}
