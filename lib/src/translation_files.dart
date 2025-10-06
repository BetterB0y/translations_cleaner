import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

/// Get list of all `*.arb` files in `arbDir`
List<FileSystemEntity> translationFiles(String arbDir) {
  final arbFile = Glob("$arbDir/**.arb");
  return arbFile.listSync(followLinks: false);
}
