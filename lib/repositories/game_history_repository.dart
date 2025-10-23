import 'package:dino_run/models/game/history.dart';

abstract class GameHistoryRepository {
  Future<void> add(History history);
  List<History> all();
}
