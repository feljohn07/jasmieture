import 'package:dino_run/models/game/player.dart';
import 'package:dino_run/repositories/player_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

// part 'player_data.g.dart';

// This class stores the player progress presistently.
// @HiveType(typeId: 0)
// class PlayerData extends ChangeNotifier with HiveObjectMixin {
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  late PlayerRepository playerRepository;

  PlayerData(this.playerRepository);
}
