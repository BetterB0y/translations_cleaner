import 'dart:io';

import 'package:translations_cleaner/src/models/term.dart';
import 'package:translations_cleaner/src/project_files.dart';
import 'package:translations_cleaner/src/translation_dir.dart';
import 'package:translations_cleaner/src/translation_terms.dart';

/// Searches through all `*.arb` files in `arbDir` to check which translation terms
/// have not been used.
Set<Term> findUnusedTerms() {
  print('FETCHING ALL THE TRANSLATION TERMS 🌏');
  final arbDir = getTranslationDir();
  final terms = getTranslationTerms(arbDir);
  print('FETCHING ALL THE DART FILES TO LOOK THROUGH 🏗');
  final dartFiles = getDartFiles(arbDir);
  print('LOOKING THROUGH FILES TO FIND UNUSED TERMS 👀');
  final unusedTerms = Set<Term>.from(terms);

  for (final file in dartFiles) {
    final content = File(file.path).readAsStringSync();
    for (final arb in terms) {
      if (content.contains(arb.key)) {
        unusedTerms.remove(arb);
      }
    }
  }
  return unusedTerms;
}
