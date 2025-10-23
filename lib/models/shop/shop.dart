// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'package:dino_run/models/shop/background.dart';
import 'package:dino_run/models/shop/character.dart';
import 'package:dino_run/models/shop/item.dart';

part 'shop.g.dart';

@HiveType(typeId: 9)
class Shop extends HiveObject {
  @HiveField(0)
  int star;
  @HiveField(1)
  Character characterSelected;
  @HiveField(2)
  Item headItemSelected;
  @HiveField(3)
  Item eyeItemSelected;
  @HiveField(4)
  Item shirtItemSelected;
  @HiveField(5)
  Background backgroundSelected;

  Shop({
    required this.star,
    required this.characterSelected,
    required this.headItemSelected,
    required this.eyeItemSelected,
    required this.shirtItemSelected,
    required this.backgroundSelected,
  });

  @override
  String toString() {
    return 'Shop(star: $star, characterSelected: $characterSelected, headItemSelected: $headItemSelected, eyeItemSelected: $eyeItemSelected, shirtItemSelected: $shirtItemSelected, backgroundSelected: $backgroundSelected)';
  }
}
