import '../../models/player.dart';

abstract class SavePlayerService {
  Future<void> save(Player player);
}
