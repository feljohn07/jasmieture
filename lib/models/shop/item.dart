// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 6)
class Item extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double riveId;

  @HiveField(5)
  String riveInputCategory;

  @HiveField(6)
  String path;

  @HiveField(2)
  int cost;

  @HiveField(4)
  bool purchased;

  Item({
    required this.name,
    required this.riveId,
    required this.riveInputCategory,
    required this.path,
    required this.cost,
    required this.purchased,
  });

  @override
  String toString() {
    return 'Item(name: $name, riveId: $riveId, riveInputCategory: $riveInputCategory, path: $path, cost: $cost, purchased: $purchased)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.riveId == riveId &&
      other.riveInputCategory == riveInputCategory &&
      other.path == path &&
      other.cost == cost &&
      other.purchased == purchased;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      riveId.hashCode ^
      riveInputCategory.hashCode ^
      path.hashCode ^
      cost.hashCode ^
      purchased.hashCode;
  }
}
