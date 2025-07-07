import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

part 'licences_page_controller.g.dart';

@riverpod
Future<List<LicenseEntry>> fetchLicences(Ref ref) {
  return LicenseRegistry.licenses
      .fold<List<LicenseEntry>>([], (prev, licence) {
        prev.add(licence);
        return prev;
      })
      .then(combineLicenseEntries);
}

@visibleForTesting
List<LicenseEntry> combineLicenseEntries(List<LicenseEntry> entries) {
  final packageParagraphsMap = <String, String>{};

  // Group and combine paragraphs by package name.
  for (final entry in entries) {
    for (final packageName in entry.packages) {
      final existingParagraphs = packageParagraphsMap[packageName] ?? '';
      final combinedParagraphs = entry.paragraphs
          .map((paragraph) => paragraph.text)
          .join('\n\n'); // Assumes paragraphs are separated by two newlines.
      packageParagraphsMap[packageName] = [
        existingParagraphs,
        combinedParagraphs,
      ].where((text) => text.isNotEmpty).join('\n\n');
    }
  }

  // Convert the map back into a list of LicenseEntry, with unique packages.
  final List<LicenseEntry> combinedEntries = packageParagraphsMap.entries.map((
    e,
  ) {
    return LicenseEntryWithLineBreaks([e.key], e.value);
  }).toList();

  return combinedEntries;
}
