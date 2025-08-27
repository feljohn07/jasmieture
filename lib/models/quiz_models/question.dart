import 'package:hive/hive.dart';
import 'package:dino_run/models/quiz_models/choice.dart';
part 'question.g.dart';

@HiveType(typeId: 4)
class Question extends HiveObject {
  @HiveField(0)
  int questionNumber;

  @HiveField(1)
  String question;

  @HiveField(2)
  List<Choice> choices;

  @HiveField(3)
  String correctChoice;

  Question({
    required this.questionNumber,
    required this.question,
    required this.choices,
    required this.correctChoice,
  });
}