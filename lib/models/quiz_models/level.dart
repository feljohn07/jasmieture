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

  Level({required this.level, required this.chapters, required this.title});
}
