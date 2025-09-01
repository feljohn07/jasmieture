import 'package:dino_run/models/quiz_models/chapter.dart';
import 'package:dino_run/models/quiz_models/choice.dart';
import 'package:dino_run/models/quiz_models/level.dart';
import 'package:dino_run/models/quiz_models/question.dart';

class LevelParser {
  static List<Level> fromJson(List<dynamic> json) {
    return json.map((levelJson) {
      return Level(
        level: levelJson['level'],
        title: levelJson['title'],
        chapters: (levelJson['chapters'] as List).map((chapJson) {
          return Chapter(
            chapter: chapJson['chapter'],
            title: chapJson['title'],
            questions: (chapJson['questions'] as List).map((qJson) {
              return Question(
                questionNumber: qJson['questionNumber'],
                question: qJson['question'],
                audio: qJson['audio'],
                correctChoice: qJson['correctChoice'],
                choices: (qJson['choices'] as List).map((cJson) {
                  return Choice(
                    choiceId: cJson['choiceId'],
                    choice: cJson['choice'],
                    imagePath: cJson['imagePath'],
                  );
                }).toList(),
              );
            }).toList(),
          );
        }).toList(),
      );
    }).toList();
  }
}
