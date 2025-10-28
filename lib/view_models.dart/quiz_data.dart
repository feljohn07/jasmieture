import 'dart:async';

import 'package:dino_run/game/audio_manager.dart';
import 'package:dino_run/main.dart';
import 'package:dino_run/models/game/history.dart';
import 'package:dino_run/models/quiz_models/chapter.dart';
import 'package:dino_run/models/quiz_models/choice.dart';
import 'package:dino_run/models/quiz_models/level.dart';
import 'package:dino_run/repositories/audio_repository.dart';
import 'package:dino_run/repositories/game_history_repository.dart';
import 'package:dino_run/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:dino_run/models/quiz_models/question.dart';
import 'package:dino_run/repositories/lesson_repository.dart';

class QuizData extends ChangeNotifier {
  final LessonRepository _lessonRepository;
  final SettingsRepository _settingsRepository;
  final GameHistoryRepository _gameHistoryRepository;

  QuizData(this._lessonRepository, this._settingsRepository, this._gameHistoryRepository);

  String get language => _settingsRepository.getSettings().language;
  List<History> get histories => _gameHistoryRepository.all().reversed.toList();

  int level = 0;
  int chapter = 0;

  int _lives = 3;
  int score = 0;
  int get lives => _lives;

  int get bonus {
    if (elapsedSeconds <= 600 && elapsedSeconds >= 301) {
      return 2;
    } else if (elapsedSeconds <= 300 && elapsedSeconds >= 121) {
      return 3;
    } else if (elapsedSeconds <= 120 && elapsedSeconds >= 0) {
      return 5;
    }
    return 0;
  }

  set lives(int value) {
    if (value <= 3 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }

  void setLevel(int level) {
    this.level = level;
    notifyListeners();
  }

  void setChapter(int chapter) {
    this.chapter = chapter;
    notifyListeners();
  }

  List<Level> get levels => _lessonRepository.getAllLevels(language);
  List<Chapter> get chapters => _lessonRepository.getChapters(language, level);

  List<Question> questions = [];

  int totalQuestions = 0;
  int get remainingQuestions => questions.length;

  Future<void> initialize(int level, int chapter) async {
    // TODO -> retrieve questions from Hive (database)
    this.level = level;
    this.chapter = chapter;

    score = 0;
    _lives = 3;

    questions = List<Question>.from(
      _lessonRepository.getQuestions(language, level, chapter),
    )..shuffle();

    totalQuestions = questions.length;
    // print(questions.length);
    notifyListeners();
  }

  Question? get question {
    // DONE -> return the latest question
    return questions.elementAtOrNull(0);
  }

  List<Choice> get choices {
    List<Choice> values = question?.choices ?? [];
    // values.shuffle();

    // values.forEach((value) => print(value.choice));
    return values;
  }

  Future<void> check(String answerId, Future<void> Function(bool isCorrect) callback) async {
    final isCorrect = questions.first.correctChoice == answerId;

    if (isCorrect) {
      AudioManager.instance.playSfx(AudioSfx.correctAnswer);
    } else {
      AudioManager.instance.playSfx(AudioSfx.wrongAnswer);
    }

    await callback(isCorrect);

    if (isCorrect) {
      questions.removeAt(0);
      score++;
      notifyListeners();
    } else {
      lives--;
    }
  }

  void unlockNextChapter() {
    Level level = levels.lastWhere((level) => level.level == this.level);
    Chapter chapter = chapters.lastWhere((chapter) => chapter.chapter == this.chapter);

    // meaning, it hasnt reach the last item
    bool hasNextChapter = (chapters.indexOf(chapter) + 1) != chapters.length;
    int currentChapterIndex = chapters.indexOf(chapter);

    if (hasNextChapter) {
      Chapter nextChapter = chapters[currentChapterIndex + 1];
      lessonRepository.unlockChapter(nextChapter);
    } else {
      int currentLevelIndex = levels.indexOf(level);
      bool hasNextLevel = (levels.indexOf(level) + 1) != levels.length;

      if (hasNextLevel) {
        Level nextLevel = levels[currentLevelIndex + 1];
        lessonRepository.unlockLevel(nextLevel);
        lessonRepository.unlockChapter(nextLevel.chapters[0]);
      }
    }
  }

  /// TODO - swap to [Stopwatch] class
  // --------------- Timer -------------------
  int _elapsedSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => _isRunning;

  void startTimer() {
    if (_isRunning) return; // Prevent double start
    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _elapsedSeconds = 0;
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void storeHistory() {
    _gameHistoryRepository.add(History(level: level, chapter: chapter, score: score, timeTaken: _elapsedSeconds));
  }
}
