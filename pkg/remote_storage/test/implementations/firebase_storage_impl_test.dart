import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remote_storage/exceptions/remote_storage_exceptions.dart';
import 'package:remote_storage/implementations/firebase_storage_impl.dart';
import 'package:remote_storage/models/storage_meta_data.dart';

import '../helpers/firebase_storage_test_mocks.dart';

FirebaseException _storageException({required String code}) {
  return FirebaseException(
    plugin: 'firebase_storage',
    code: code,
    message: 'failure',
  );
}

void main() {
  late MockFirebaseStorage mockStorage;
  late MockReference mockRootRef;
  late MockReference mockPathRef;
  late FirebaseRemoteStorageImpl impl;

  setUpAll(registerFirebaseStorageFallbacks);

  setUp(() {
    mockStorage = MockFirebaseStorage();
    mockRootRef = MockReference();
    mockPathRef = MockReference();

    when(() => mockStorage.ref()).thenReturn(mockRootRef);
    when(() => mockRootRef.child(any())).thenReturn(mockPathRef);
    when(() => mockRootRef.bucket).thenReturn('test-bucket');
    when(() => mockRootRef.fullPath).thenReturn('full/path');
    when(() => mockRootRef.name).thenReturn('file.txt');

    impl = FirebaseRemoteStorageImpl(firebaseStorage: mockStorage);
  });

  test('forwards root reference getters', () {
    expect(impl.bucket, 'test-bucket');
    expect(impl.fullPath, 'full/path');
    expect(impl.name, 'file.txt');
  });

  group('delete', () {
    test('returns none when Firebase delete succeeds', () async {
      when(() => mockPathRef.delete()).thenAnswer((_) async {});

      final result = await impl.delete(path: 'avatars/a.png');

      expect(result.isNone(), isTrue);
      verify(() => mockRootRef.child('avatars/a.png')).called(1);
    });

    test('returns a mapped exception when Firebase delete fails', () async {
      when(() => mockPathRef.delete()).thenThrow(
        _storageException(code: 'not-found'),
      );

      final result = await impl.delete(path: 'avatars/a.png');

      expect(result.isSome(), isTrue);
      result.fold(
        () => fail('expected some'),
        (error) => expect(error, isA<FirebaseRemoteStorageException>()),
      );
    });
  });

  group('getData', () {
    test('returns bytes when Firebase getData succeeds', () async {
      final bytes = Uint8List.fromList([9, 8, 7]);
      when(() => mockPathRef.getData(any())).thenAnswer((_) async => bytes);

      final result = await impl.getData(path: 'data.bin');

      expect(result, right<CoreException, Uint8List?>(bytes));
    });

    test('returns a mapped exception when Firebase getData fails', () async {
      when(() => mockPathRef.getData(any())).thenThrow(
        _storageException(code: 'retry'),
      );

      final result = await impl.getData(path: 'data.bin', maxSize: 512);

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error, isA<FirebaseRemoteStorageException>()),
        (_) => fail('expected left'),
      );
      verify(() => mockPathRef.getData(512)).called(1);
    });
  });

  group('getDownloadURL', () {
    test('returns the download url when Firebase succeeds', () async {
      when(
        () => mockPathRef.getDownloadURL(),
      ).thenAnswer((_) async => 'https://cdn.example/object');

      final result = await impl.getDownloadURL(path: 'object');

      expect(
        result,
        right<CoreException, String>('https://cdn.example/object'),
      );
    });

    test('returns a mapped exception when Firebase fails', () async {
      when(() => mockPathRef.getDownloadURL()).thenThrow(
        _storageException(code: 'unauthorized'),
      );

      final result = await impl.getDownloadURL(path: 'object');

      expect(result.isLeft(), isTrue);
    });
  });

  group('uploads', () {
    late CompletedUploadTask uploadTask;
    late MockTaskSnapshot mockSnapshot;
    late MockReference mockSnapshotRef;
    final metadata = StorageMetadata(contentType: 'image/png');

    setUp(() {
      mockSnapshot = MockTaskSnapshot();
      mockSnapshotRef = MockReference();
      uploadTask = CompletedUploadTask(mockSnapshot);

      when(() => mockSnapshot.ref).thenReturn(mockSnapshotRef);
      when(
        () => mockSnapshotRef.getDownloadURL(),
      ).thenAnswer((_) async => 'https://cdn.example/uploaded');
    });

    test('putData uploads bytes and resolves the download url', () async {
      when(
        () => mockPathRef.putData(any(), any()),
      ).thenAnswer((_) => uploadTask);

      final result = await impl.putData(
        data: Uint8List.fromList([1]),
        path: 'uploads/a.png',
        metadata: metadata,
      );

      expect(
        result,
        right<CoreException, String>('https://cdn.example/uploaded'),
      );
      verify(() => mockPathRef.putData(any(), any())).called(1);
    });

    test('putData maps Firebase failures', () async {
      when(() => mockPathRef.putData(any(), any())).thenThrow(
        _storageException(code: 'quota'),
      );

      final result = await impl.putData(
        data: Uint8List.fromList([1]),
        path: 'uploads/a.png',
      );

      expect(result.isLeft(), isTrue);
    });

    test('putBlob uploads a blob and resolves the download url', () async {
      when(() => mockPathRef.putBlob(any<Object>(), any())).thenAnswer(
        (_) => uploadTask,
      );
      final blob = Object();

      final result = await impl.putBlob(
        blob: blob,
        path: 'uploads/blob',
        metadata: metadata,
      );

      expect(
        result,
        right<CoreException, String>('https://cdn.example/uploaded'),
      );
      verify(() => mockPathRef.putBlob(blob, any())).called(1);
    });

    test('putBlob maps Firebase failures', () async {
      when(() => mockPathRef.putBlob(any<Object>(), any())).thenThrow(
        _storageException(code: 'invalid'),
      );

      final result = await impl.putBlob(blob: Object(), path: 'uploads/blob');

      expect(result.isLeft(), isTrue);
    });

    test('putString uploads text and resolves the download url', () async {
      when(
        () => mockPathRef.putString(any(), metadata: any(named: 'metadata')),
      ).thenAnswer((_) => uploadTask);

      final result = await impl.putString(
        data: 'hello',
        path: 'uploads/hello.txt',
        metadata: metadata,
      );

      expect(
        result,
        right<CoreException, String>('https://cdn.example/uploaded'),
      );
    });

    test('putString maps Firebase failures', () async {
      when(
        () => mockPathRef.putString(any(), metadata: any(named: 'metadata')),
      ).thenThrow(_storageException(code: 'canceled'));

      final result = await impl.putString(
        data: 'hello',
        path: 'uploads/hello.txt',
      );

      expect(result.isLeft(), isTrue);
    });

    test('putFile uploads a file and resolves the download url', () async {
      when(() => mockPathRef.putFile(any(), any())).thenAnswer(
        (_) => uploadTask,
      );
      final file = File('firebase_storage_impl_put_file_test.txt');
      addTearDown(() {
        if (file.existsSync()) {
          file.deleteSync();
        }
      });

      final result = await impl.putFile(
        file: file,
        path: 'uploads/file.txt',
        metadata: metadata,
      );

      expect(
        result,
        right<CoreException, String>('https://cdn.example/uploaded'),
      );
    });

    test('putFile maps Firebase failures', () async {
      when(() => mockPathRef.putFile(any(), any())).thenThrow(
        _storageException(code: 'unknown'),
      );

      final result = await impl.putFile(
        file: File('missing-upload.txt'),
        path: 'uploads/file.txt',
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('writeToFile', () {
    test('returns none when Firebase writeToFile succeeds', () async {
      when(
        () => mockPathRef.writeToFile(any()),
      ).thenAnswer((_) => CompletedDownloadTask());
      final file = File('firebase_storage_impl_write_test.txt');
      addTearDown(() {
        if (file.existsSync()) {
          file.deleteSync();
        }
      });

      final result = await impl.writeToFile(
        file: file,
        path: 'downloads/a.bin',
      );

      expect(result.isNone(), isTrue);
    });

    test(
      'returns a mapped exception when Firebase writeToFile fails',
      () async {
        when(() => mockPathRef.writeToFile(any())).thenThrow(
          _storageException(code: 'write-failed'),
        );

        final result = await impl.writeToFile(
          file: File('firebase_storage_impl_write_fail_test.txt'),
          path: 'downloads/a.bin',
        );

        expect(result.isSome(), isTrue);
      },
    );
  });
}
