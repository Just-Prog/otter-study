import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

Future<File> getLogsPath() async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  final String filename = p.join(dir, "otterstudy_logs.log");
  final File file = File(filename);
  if (!await file.exists()) {
    await file.create(recursive: true);
  }
  return file;
}
