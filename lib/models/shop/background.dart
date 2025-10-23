// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'background.g.dart';

@HiveType(typeId: 7)
class Background extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> parallax;

  @HiveField(5)
  String thumbnail;

  @HiveField(2)
  int cost;

  @HiveField(3)
  bool purchased;

  Background({
    required this.name,
    required this.parallax,
    required this.thumbnail,
    required this.cost,
    required this.purchased,
  });

  @override
  String toString() {
    return 'Background(name: $name, parallax: $parallax, thumbnail: $thumbnail, cost: $cost, purchased: $purchased)';
  }

  @override
  bool operator ==(covariant Background other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      listEquals(other.parallax, parallax) &&
      other.thumbnail == thumbnail &&
      other.cost == cost &&
      other.purchased == purchased;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      parallax.hashCode ^
      thumbnail.hashCode ^
      cost.hashCode ^
      purchased.hashCode;
  }
}
