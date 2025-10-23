import 'package:dino_run/models/game/history.dart';
import 'package:dino_run/repositories/data/datasource.dart';
import 'package:dino_run/repositories/game_history_repository.dart';
import 'package:hive/hive.dart';

class GameHistoryRepositoryImpl extends GameHistoryRepository {
  final Datasource datasource;

  Box<History> get _box => datasource.historyBox;

  GameHistoryRepositoryImpl({required this.datasource});

  @override
  Future<void> add(History history) async {
    await _box.add(history);
  }

  @override
  List<History> all() {
    return _box.values.toList();
  }
}
