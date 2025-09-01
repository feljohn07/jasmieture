import 'dart:async';

import 'package:dino_run/models/quiz_models/chapter.dart';
import 'package:dino_run/models/quiz_models/level.dart';
import 'package:flutter/material.dart';
import 'package:dino_run/models/quiz_models/question.dart';
import 'package:dino_run/repositories/lesson_repository.dart';

class QuizData extends ChangeNotifier {
  final LessonRepository _lessonRepository;

  QuizData(this._lessonRepository);

  int level = 0;
  int chapter = 0;

  int _lives = 5;
  int get lives => _lives;

  set lives(int value) {
    if (value <= 5 && value >= 0) {
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

  Future<List<Level>> get levels async => await _lessonRepository.getAllLevels();
  Future<List<Chapter>> getChapters(int level) async => _lessonRepository.getChapters(level);

  int score = 0;
  List<Question> questions = [];

  int totalQuestions = 0;
  get remainingQuestions => questions.length;

  Future<void> initialize(int level, int chapter) async {
    // TODO -> retrieve questions from Hive (database)
    this.level = level;
    this.chapter = chapter;

    score = 0;
    _lives = 5;

    questions = List<Question>.from(
      await _lessonRepository.getQuestions(level, chapter),
    );

    totalQuestions = questions.length;
    // print(questions.length);
    notifyListeners();
  }

  Question? get question {
    // TODO -> return the latest question
    return questions.elementAtOrNull(0);
  }

  Future<void> check(
    String answerId,
    Function(bool isCorrect, bool gameEnded) callback,
  ) async {
    if (questions.isEmpty) {
      // No more questions left, game ended
      callback(false, true);
      return;
    }

    final isCorrect = questions.first.correctChoice == answerId;

    if (isCorrect) {
      questions.removeAt(0);
      score++;
      notifyListeners();
    } else {
      lives--;
    }

    // gameEnded = list is now empty after removal
    callback(isCorrect, questions.isEmpty);
  }

  void gameOver() {
    // TODO
    // calculate the score and the bonus stars based on the player's time taken to complete the game
    // Insert
  }

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
}
