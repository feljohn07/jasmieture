import 'package:dino_run/models/quiz_models/level.dart';
import 'package:hive/hive.dart';

part 'language.g.dart';

@HiveType(typeId: 10)
class Language extends HiveObject {
  @HiveField(0)
  String language;
  @HiveField(1)
  List<Level> levels;

  Language({required this.language, required this.levels});
}
