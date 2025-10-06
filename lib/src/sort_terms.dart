import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:translations_cleaner/src/translation_dir.dart';
import 'package:translations_cleaner/src/translation_files.dart';

Future<void> sortTerms(ArgResults? argResults) async {
  final int indent = int.tryParse(argResults?['indent'] ?? "") ?? 2;

  final arbDir = getTranslationDir();
  final files = translationFiles(arbDir);

  print('SORTING TRANSLATION TERMS IN ${files.length} FILES ⚙️');
  await Future.wait(files.map((file) async {
    final contents = await File(file.path).readAsString();
    final sorted = _sortContent(contents, indent);
    await File(file.path).writeAsString(sorted);
  }));
  print('ALL TRANSLATION FILES SORTED SUCCESSFULLY 💪 🚀');
}

String _sortContent(String contents, int indent) {
  final JsonEncoder encoder = JsonEncoder.withIndent(' ' * indent);
  final Map<String, dynamic> entries = json.decode(contents);

  final sorted = LinkedHashMap.fromEntries(
    entries.entries.toList()
      ..sort((MapEntry<String, dynamic> entryA, MapEntry<String, dynamic> entryB) {
        final String keyA = entryA.key;
        final String keyB = entryB.key;
        if (keyA.startsWith('@') || keyB.startsWith('@')) {
          if (keyA.startsWith('@@')) {
            return keyB.startsWith('@@') ? keyA.compareTo(keyB) : -1;
          }
          if (keyB.startsWith('@@')) {
            return 1;
          }

          final aNoAt = keyA.startsWith('@') ? keyA.substring(1) : keyA;
          final bNoAt = keyB.startsWith('@') ? keyB.substring(1) : keyB;

          final int compared = aNoAt.compareTo(bNoAt);
          if (compared != 0) {
            return compared;
          }

          return keyA.compareTo(keyB) * -1;
        }

        return keyA.compareTo(keyB);
      }),
  );

  return encoder.convert(sorted);
}
