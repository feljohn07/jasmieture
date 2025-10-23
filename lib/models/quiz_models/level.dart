// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'package:dino_run/models/quiz_models/chapter.dart';

part 'level.g.dart';

@HiveType(typeId: 2)
class Level extends HiveObject {
  @HiveField(0)
  int level;

  @HiveField(1)
  List<Chapter> chapters;

  @HiveField(2)
  String title;

  @HiveField(3)
  bool lock;

  @HiveField(4)
  String difficulty;

  Level({
    required this.level,
    required this.chapters,
    required this.title,
    required this.lock,
    required this.difficulty,
  });
}
