import 'package:dino_run/models/game/player.dart';

abstract class PlayerRepository {
  // Future<void> initialize();
  Player? getPlayer();
  Future<void> createPlayer(Player player);
  Future<void> updatePlayer(Player player);
}
