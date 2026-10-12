import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui/features/licences_viewer/controllers/licences_page_controller.dart';

import '../../../shared/provider_container.dart';

class _License extends LicenseEntry {
  _License(this.packages, this.paragraphs);

  @override
  final List<String> packages;

  @override
  final List<LicenseParagraph> paragraphs;
}

void main() {
  group('combineLicenseEntries', () {
    test('returns an empty list when there are no entries', () {
      expect(combineLicenseEntries(const []), isEmpty);
    });

    test('groups paragraphs by package and drops empty text', () {
      final combined = combineLicenseEntries([
        _License(
          ['shared', 'only'],
          const [
            LicenseParagraph('alpha', 0),
            LicenseParagraph('beta', 1),
          ],
        ),
        _License(
          ['shared'],
          const [LicenseParagraph('gamma', 0)],
        ),
        _License(['blank'], const []),
        _License(
          const [],
          const [LicenseParagraph('unused', 0)],
        ),
      ]);

      LicenseEntryWithLineBreaks entryFor(String package) {
        return combined.whereType<LicenseEntryWithLineBreaks>().firstWhere(
          (entry) => entry.packages.contains(package),
        );
      }

      expect(combined, hasLength(3));
      expect(entryFor('shared').text, 'alpha\n\nbeta\n\ngamma');
      expect(entryFor('only').text, 'alpha\n\nbeta');
      expect(entryFor('blank').text, isEmpty);
      expect(
        combined.where((entry) => entry.packages.contains('unused')),
        isEmpty,
      );
    });
  });

  test('fetchLicences folds registry entries and combines them', () async {
    LicenseRegistry.reset();
    addTearDown(LicenseRegistry.reset);
    LicenseRegistry.addLicense(() async* {
      yield const LicenseEntryWithLineBreaks(<String>['unit_pkg'], 'Hello');
      yield const LicenseEntryWithLineBreaks(<String>['unit_pkg'], 'World');
    });

    final container = makeProviderContainer();
    final result = await container.read(fetchLicencesPod.future);

    expect(result, hasLength(1));
    final entry = result.single as LicenseEntryWithLineBreaks;
    expect(entry.packages, ['unit_pkg']);
    expect(entry.text, 'Hello\n\nWorld');
  });
}
