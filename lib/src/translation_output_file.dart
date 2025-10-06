import 'dart:io';

import 'package:yaml/yaml.dart';

/// Reads `output-localization-file` from `l10n.yaml`
String getOutputLocalizationFileName() {
  final projectDir = Directory.current;
  final l10nFile = File('${projectDir.path}/l10n.yaml');

  if (l10nFile.existsSync()) {
    try {
      final yaml = loadYaml(l10nFile.readAsStringSync());
      if (yaml is Map && yaml['output-localization-file'] is String) {
        return yaml['output-localization-file'];
      }
    } catch (e) {
      print('⛔️ Failed to parse l10n.yaml: $e');
    }
  }

  return 'app_localizations.dart';
}
