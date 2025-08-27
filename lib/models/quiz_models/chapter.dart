import 'package:hive/hive.dart';
import 'package:dino_run/models/quiz_models/question.dart';
part 'chapter.g.dart';

@HiveType(typeId: 3)
class Chapter extends HiveObject {
  @HiveField(0)
  int chapter;

  @HiveField(1)
  List<Question> questions;

  Chapter({required this.chapter, required this.questions});
}