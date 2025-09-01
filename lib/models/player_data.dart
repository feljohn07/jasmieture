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

  // TODO - delete this
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

  // List<String> characters = ['Character 1', 'Character 2', 'Character 3', 'Character 4', 'Character 5', 'Character 6'];

  @HiveField(6)
  String character = 'Character 1';

  void setCharacter(String value) {
    print('character switched = ${value}');
    character = value;
    notifyListeners();
    save();
  }
  // Player Details

  // firstName
  @HiveField(7)
  String firstName = '';
  // middleName
  @HiveField(8)
  String middleName = '';
  // lastName
  @HiveField(9)
  String lastName = '';
  // age
  @HiveField(10)
  String age = '';
  // section
  @HiveField(11)
  String section = '';
}
