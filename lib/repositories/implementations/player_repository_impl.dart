// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'package:dino_run/models/game/player.dart';
import 'package:dino_run/repositories/data/datasource.dart';
import 'package:dino_run/repositories/player_repository.dart';

class PlayerRepositoryImp extends PlayerRepository {
  final Datasource datasource;

  PlayerRepositoryImp({required this.datasource});

  Box<Player> get _box => datasource.playerBox;

  // static const String boxName = 'player';
  // late Box<Player> _box;

  // @override
  // Future<void> initialize() async {
  //   if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(PlayerAdapter());
  //   _box = await Hive.openBox<Player>(boxName);
  // }

  @override
  Future<void> createPlayer(Player player) async {
    await _box.add(player);
  }

  @override
  Future<void> updatePlayer(Player player) async {
    await player.save();
  }

  @override
  Player? getPlayer() {
    return _box.values.firstOrNull;
  }
}
