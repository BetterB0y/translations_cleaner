import 'dart:io';

import 'package:yaml/yaml.dart';

/// Reads the `arb-dir` from `l10n.yaml`, or falls back to `lib/l10n`.
String getTranslationDir() {
  final projectDir = Directory.current;
  final l10nFile = File('${projectDir.path}/l10n.yaml');

  if (l10nFile.existsSync()) {
    try {
      final yaml = loadYaml(l10nFile.readAsStringSync());
      if (yaml is Map && yaml['arb-dir'] is String) {
        return yaml['arb-dir'];
      }
    } catch (e) {
      print('⛔️ Failed to parse l10n.yaml: $e');
    }
  }

  const arbDir = 'lib/l10n';
  stderr.writeln('⚠️ l10n.yaml not found, using default: $arbDir');
  final dir = Directory(arbDir);
  if (!dir.existsSync()) {
    stderr.writeln('⚠️  ARB directory "$arbDir" does not exist.');
    exit(2);
  }

  return arbDir;
}
