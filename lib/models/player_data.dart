import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'player_data.g.dart';

// This class stores the player progress presistently.
@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  // Current Level
  int level = 0;
  int chapter = 0;

  // Lets Store the
  @HiveField(1)
  int highScore = 0;

  // TODO -> test variables

  int _lives = 5;

  int get lives => _lives;

  set lives(int value) {
    if (value <= 5 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }

  int _currentScore = 0;

  int get currentScore => _currentScore;
  set currentScore(int value) {
    _currentScore = value;

    if (highScore < _currentScore) {
      highScore = _currentScore;
    }

    notifyListeners();
    shopStar += value;
    save();
  }

  setLevel(int level) {
    this.level = level;
    notifyListeners();
  }

  setChapter(int chapter) {
    this.chapter = chapter;
    notifyListeners();
  }

  // -------------- Shop variables and character customization ----------------------------------

  @HiveField(2)
  int shopStar = 0;

  // Selected Items for the character
  @HiveField(3)
  double headItem = 0;

  set setHeadItem(double value) {
    headItem = value + 1;
    notifyListeners();
    save();
  }

  @HiveField(4)
  double eyeItem = 0;

  set setEyeItem(double value) {
    eyeItem = value + 1;
    notifyListeners();
    save();
  }

  @HiveField(5)
  double shirtItem = 0;

  set setShirtItem(double value) {
    shirtItem = value + 1;
    notifyListeners();
    save();
  }

  double character = 0;
}
