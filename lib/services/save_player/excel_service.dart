import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simon_game/services/save_player/save_player.dart';
import '../../models/player.dart';

class ExcelService extends SavePlayerService {
  static const String _fileName = 'players.xlsx';
  static const String _sheetName = 'Registros';

  @override
  Future<void> save(Player player) async {
    final directory = await getApplicationDocumentsDirectory();
    print('📁 Excel path: ${directory.path}/players.xlsx');
    final filePath = '${directory.path}/$_fileName';
    final file = File(filePath);

    Excel excel;

    if (await file.exists()) {
      excel = Excel.decodeBytes(await file.readAsBytes());
    } else {
      excel = Excel.createExcel();
      excel.rename(excel.getDefaultSheet()!, _sheetName);

      excel[_sheetName].appendRow([
        // Crea las columnas
        TextCellValue('Id'),
        TextCellValue('Nombre'),
        TextCellValue('Apellido'),
        TextCellValue('Celular'),
        TextCellValue('Email'),
      ]);
    }

    excel[_sheetName].appendRow([
      TextCellValue(player.id.toString()),
      TextCellValue(player.name),
      TextCellValue(player.lastName),
      TextCellValue(player.phone),
      TextCellValue(player.email),
    ]);

    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes, flush: true);
    }
  }
}
