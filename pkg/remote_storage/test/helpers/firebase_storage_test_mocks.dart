import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MockTaskSnapshot extends Mock implements TaskSnapshot {}

class CompletedUploadTask extends Fake implements UploadTask {
  CompletedUploadTask(this._snapshot);

  final TaskSnapshot _snapshot;

  @override
  Future<S> then<S>(
    FutureOr<S> Function(TaskSnapshot) onValue, {
    Function? onError,
  }) async {
    return onValue(_snapshot);
  }
}

class CompletedDownloadTask extends Fake implements DownloadTask {
  @override
  Future<S> then<S>(
    FutureOr<S> Function(TaskSnapshot) onValue, {
    Function? onError,
  }) async {
    return onValue(_FakeTaskSnapshot());
  }
}

class _FakeTaskSnapshot implements TaskSnapshot {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void registerFirebaseStorageFallbacks() {
  registerFallbackValue(Uint8List(0));
  registerFallbackValue(File('fallback.txt'));
  registerFallbackValue(SettableMetadata());
  registerFallbackValue(Object());
}
