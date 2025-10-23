// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 8)
class Character extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String riveId;

  @HiveField(2)
  int cost;

  @HiveField(3)
  bool purchased;

  Character({
    required this.name,
    required this.riveId,
    required this.cost,
    required this.purchased,
  });

  @override
  String toString() {
    return 'Character(name: $name, riveId: $riveId, cost: $cost, purchased: $purchased)';
  }

  @override
  bool operator ==(covariant Character other) {
    if (identical(this, other)) return true;

    return other.name == name && other.riveId == riveId && other.cost == cost && other.purchased == purchased;
  }

  @override
  int get hashCode {
    return name.hashCode ^ riveId.hashCode ^ cost.hashCode ^ purchased.hashCode;
  }
}
