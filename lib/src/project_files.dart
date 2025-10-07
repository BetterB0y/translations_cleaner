import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:translations_cleaner/src/translation_output_file.dart';

/// Get a list of all `.dart` files in the project
/// excluding the localization output files
List<FileSystemEntity> getDartFiles(String arbDir) {
  final path = Directory.current.path;
  final dartFile = Glob("$path/lib/**.dart");
  final dartFiles = <FileSystemEntity>[];
  final outputLocalizationFile = getOutputLocalizationFileName().replaceFirst(RegExp(r'\.dart$'), '');

  for (final entity in dartFile.listSync(followLinks: false)) {
    if (entity.path.contains("$arbDir/$outputLocalizationFile")) continue;
    dartFiles.add(entity);
  }

  return dartFiles;
}
