import 'package:hive/hive.dart';

part 'player.g.dart';

@HiveType(typeId: 1)
class Player extends HiveObject {
  @HiveField(0)
  String firstname;
  @HiveField(1)
  String lastname;
  @HiveField(2)
  String middlename;
  @HiveField(3)
  String section;
  @HiveField(4)
  int age;

  Player({
    required this.firstname,
    required this.lastname,
    required this.middlename,
    required this.section,
    required this.age,
  });
}
