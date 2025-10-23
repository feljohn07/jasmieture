import 'package:dino_run/repositories/settings_repository.dart';
import 'package:flutter/foundation.dart';

enum Languages {
  english,
  cebuano,
}

class LanguageProvider extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  LanguageProvider(this._settingsRepository);

  String get selectedLanguage => _settingsRepository.getSettings().language;

  void changeLanguage(String language) {
    _settingsRepository.setLanguage(language);
    notifyListeners();
  }

  String get language => translate(english: 'language', cebuano: 'linguahe');
  String get effects => translate(english: 'effects', cebuano: 'epeks');
  String get music => translate(english: 'music', cebuano: 'musika');
  String get shop => translate(english: 'shop', cebuano: 'tindahan');

  // Levels
  String get chapters => translate(english: 'chapter', cebuano: 'ka kapitulo');
  String get questions => translate(english: 'questions', cebuano: 'ka pangutana');
  String get chapter => translate(english: 'chapter', cebuano: 'kapitulo');
  String get quarter => translate(english: 'quarter', cebuano: 'kuarter');

  // Dialogs
  String get levelLockDialog => translate(
      english: 'This level is lock, please complete the current level first.',
      cebuano: 'kani na level kay naka lock, palihug humana una ang open nga level.');

  String get chapterLockDialog => translate(
      english: 'This chapter is lock, please complete the current chapter first.',
      cebuano: 'kani na kapitulo kay naka lock, palihug humana una ang open nga kapitulo.');

  // Shop
  String get selected => translate(english: 'selected', cebuano: 'gi-pili');
  String get buy => translate(english: 'buy', cebuano: 'palita');
  String get buyFor => translate(english: 'buy for', cebuano: 'paliton tag-');
  String get wala => translate(english: 'buy', cebuano: 'palita');

  String get confirmPurchase => translate(english: 'confirm purchase', cebuano: 'i-confirm pag palit');

  String get purchaseCharacterDialog1 => translate(english: 'You want to buy ', cebuano: 'Paliton nimo si');
  String get purchaseItemDialog1 => translate(english: 'You want to buy ', cebuano: 'Paliton nimo ning');

  String get forString => translate(english: 'for', cebuano: 'sa kantidad nga ');

  String get yesPlease => translate(english: 'yes please!', cebuano: 'paliton nako!');
  String get noThanks => translate(english: 'no thanks', cebuano: 'dili lang');
  String get notEnoughtStar => translate(english: 'Not Enough Star =(', cebuano: 'kulang kag start =(');

  String get head => translate(english: 'head', cebuano: 'ulo');
  String get eye => translate(english: 'eye', cebuano: 'mata');
  String get shirt => translate(english: 'shirt', cebuano: 'sanina');

  String get owned => translate(english: 'owned', cebuano: 'napalit');
  String get equiped => translate(english: 'equiped', cebuano: 'gisuot');
  String get none => translate(english: 'none', cebuano: 'wala');


  // String get level1 => translate(english: 'materials', cebuano: 'materyales');
  // String get level2 => translate(english: 'living things', cebuano: 'buhing butang');
  // String get level3 => translate(english: 'force, motion and energy', cebuano: 'Pwersa, mosyon, ug enerhiya.');
  // String get level4 => translate(english: 'earth and space', cebuano: 'Pwersa, mosyon, ug enerhiya.');

  String get easy => translate(english: 'easy', cebuano: 'sayon');
  String get medium => translate(english: 'medium', cebuano: 'Igo-igo ra');
  String get hard => translate(english: 'hard', cebuano: 'lisod');
  String get extraHard => translate(english: 'extra Hard', cebuano: 'lisod kaayo');

  String translate({required String english, required String cebuano}) {
    switch (selectedLanguage) {
      case 'english':
        return english;
      case 'cebuano':
        return cebuano;
      default:
        return '';
    }
  }
}
