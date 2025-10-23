import 'package:hive/hive.dart';
part 'history.g.dart';

@HiveType(typeId: 12)
class History extends HiveObject {
  @HiveField(0)
  int level;
  @HiveField(1)
  int chapter;
  @HiveField(2)
  int score;
  @HiveField(3)
  int timeTaken;

  History({
    required this.level,
    required this.chapter,
    required this.score,
    required this.timeTaken,
  });
}
