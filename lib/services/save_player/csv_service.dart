import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../models/player.dart';
import './save_player.dart';

class CSVService implements SavePlayerService {
  static const _fileName = 'players.csv';

  @override
  Future<void> save(Player player) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');

    final exists = await file.exists();

    final buffer = StringBuffer();

    // Header solo si el archivo no existe
    if (!exists) {
      buffer.writeln('Nombre,Apellido,Telefono,Email');
    }

    buffer.writeln(
      '${player.name},${player.lastName},${player.phone},${player.email}',
    );

    await file.writeAsString(buffer.toString(), mode: FileMode.append);
  }
}
