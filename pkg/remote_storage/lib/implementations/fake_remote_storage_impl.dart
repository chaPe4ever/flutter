import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:remote_storage/contracts/remote_storage_base.dart';
import 'package:remote_storage/models/storage_meta_data.dart';

/// No-op [RemoteStorageBase] for local runs and tests.
final class FakeRemoteStorageImpl implements RemoteStorageBase {
  /// Creates a [FakeRemoteStorageImpl].
  const FakeRemoteStorageImpl({
    this.bucket = 'fake-bucket',
    this.fullPath = '',
    this.name = '',
  });

  @override
  final String bucket;

  @override
  final String fullPath;

  @override
  final String name;

  @override
  Future<Option<CoreException>> delete({required String path}) async => none();

  @override
  Future<Either<CoreException, String>> getDownloadURL({
    required String path,
  }) async => right('https://fake.storage/$path');

  @override
  Future<Either<CoreException, Uint8List?>> getData({
    required String path,
    int maxSize = 10485760,
  }) async => right(null);

  @override
  Future<Either<CoreException, String>> putBlob({
    required dynamic blob,
    required String path,
    StorageMetadata? metadata,
  }) async => right('https://fake.storage/$path');

  @override
  Future<Either<CoreException, String>> putData({
    required Uint8List data,
    required String path,
    StorageMetadata? metadata,
  }) async => right('https://fake.storage/$path');

  @override
  Future<Either<CoreException, String>> putString({
    required String data,
    required String path,
    StorageMetadata? metadata,
  }) async => right('https://fake.storage/$path');

  @override
  Future<Either<CoreException, String>> putFile({
    required File file,
    required String path,
    StorageMetadata? metadata,
  }) async => right('https://fake.storage/$path');

  @override
  Future<Option<CoreException>> writeToFile({
    required File file,
    required String path,
  }) async => none();
}
