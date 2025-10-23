// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'package:dino_run/models/quiz_models/question.dart';

part 'chapter.g.dart';

@HiveType(typeId: 3)
class Chapter extends HiveObject {
  @HiveField(0)
  int chapter;

  @HiveField(1)
  List<Question> questions;

  // title
  @HiveField(2)
  String title;

  @HiveField(3)
  bool lock;

  @HiveField(4)
  int highScore;

  @HiveField(5)
  int timeTakenInSeconds;

  Chapter({
    required this.chapter,
    required this.questions,
    required this.title,
    required this.lock,
    required this.highScore,
    required this.timeTakenInSeconds,
  });
}
