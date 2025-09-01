import 'package:hive/hive.dart';
part 'choice.g.dart';

@HiveType(typeId: 5)
class Choice extends HiveObject {
  @HiveField(0)
  String choiceId;

  @HiveField(1)
  String choice;

  @HiveField(2)
  String imagePath;

  Choice({required this.choiceId, required this.choice, required this.imagePath});
}
