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
  await Future.wait(
    files.map((file) async {
      final path = file.path;
      final original = await File(path).readAsString();
      final sorted = _sortContent(original, indent);

      if (sorted != original) {
        await File(path).writeAsString(sorted);
      }
    }),
  );
  print('ALL TRANSLATION FILES SORTED SUCCESSFULLY 💪 🚀');
}

String _sortContent(String contents, int indent) {
  final JsonEncoder encoder = JsonEncoder.withIndent(' ' * indent);
  final dynamic decoded = json.decode(contents);

  if (decoded is! Map<String, dynamic>) {
    stderr.writeln('⛔️ Top-level JSON must be an object.');
    exit(2);
  }

  final sortedEntries = decoded.entries.toList()..sort((a, b) => arbKeyComparator(a.key, b.key));
  final sortedMap = LinkedHashMap<String, dynamic>.fromEntries(sortedEntries);

  final result = encoder.convert(sortedMap);
  return result.endsWith('\n') ? result : '$result\n';
}

/// Comparator implementing ARB-friendly ordering:
/// 1) Keys starting with `@@` come first (alphabetical among themselves)
/// 2) Normal message keys (no @) next (alphabetical)
/// 3) Single `@` metadata keys sorted by their base key (alphabetical),
///    and when base keys are equal, place the base key BEFORE its `@` metadata.
int arbKeyComparator(String a, String b) {
  if (a == b) return 0;

  final aIsAtAt = a.startsWith('@@');
  final bIsAtAt = b.startsWith('@@');
  if (aIsAtAt && bIsAtAt) return a.compareTo(b);
  if (aIsAtAt) return -1;
  if (bIsAtAt) return 1;

  final aIsAt = a.startsWith('@');
  final bIsAt = b.startsWith('@');

  if (!aIsAt && !bIsAt) return a.compareTo(b);

  final aBase = aIsAt ? a.substring(1) : a;
  final bBase = bIsAt ? b.substring(1) : b;

  final baseCompare = aBase.compareTo(bBase);
  if (baseCompare != 0) return baseCompare;

  return a.compareTo(b) * -1;
}
