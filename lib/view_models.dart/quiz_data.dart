import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dino_run/models/quiz_models/question.dart';
import 'package:dino_run/repositories/lesson_repository.dart';

class QuizData extends ChangeNotifier {
  final LessonRepository _lessonRepository;

  QuizData(this._lessonRepository);

  int level = 0;
  int chapter = 0;

  void setLevel(int level) {
    this.level = level;
    notifyListeners();
  }

  void setChapter(int chapter) {
    this.chapter = chapter;
    notifyListeners();
  }

  int score = 0;
  List<Question> questions = [];

  bool isLoadingQuestions = false;

  Future<void> initialize(int level, int chapter) async {
    // TODO -> retrieve questions from Hive (database)
    this.level = level;
    this.chapter = chapter;

    questions = List<Question>.from(
      await _lessonRepository.getQuestions(level, chapter),
    );
    print(questions.length);
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
    }

    // gameEnded = list is now empty after removal
    callback(isCorrect, questions.isEmpty);
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
