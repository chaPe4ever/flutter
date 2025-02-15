import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:remote_storage/contracts/remote_storage_base.dart';
import 'package:remote_storage/extensions/firebase_exception_extension.dart';
import 'package:remote_storage/extensions/storage_meta_data_extension.dart';
import 'package:remote_storage/models/storage_meta_data.dart';

///
final class FirebaseRemoteStorageImpl implements RemoteStorageBase {
  /// Ctr
  FirebaseRemoteStorageImpl({
    required FirebaseStorage firebaseStorage,
  }) : _storage = firebaseStorage;

  // Fields
  final FirebaseStorage _storage;

  // Getters
  @override
  String get bucket => _storage.ref().bucket;

  @override
  String get fullPath => _storage.ref().fullPath;

  @override
  String get name => _storage.ref().name;

  // Methods
  @override
  Future<Option<CoreException>> delete({required String path}) async {
    try {
      return await _storage.ref().child(path).delete().then((_) => none());
    } on FirebaseException catch (e) {
      return some(e.toFirestoreRemoteStorageEx());
    }
  }

  @override
  Future<Either<CoreException, Uint8List?>> getData({
    required String path,
    int maxSize = 10485760,
  }) async {
    try {
      return await _storage.ref().child(path).getData(maxSize).then(right);
    } on FirebaseException catch (e) {
      return left(e.toFirestoreRemoteStorageEx());
    }
  }

  @override
  Future<Either<CoreException, String>> getDownloadURL({
    required String path,
  }) async {
    try {
      return await _storage.ref().child(path).getDownloadURL().then(right);
    } on FirebaseException catch (e) {
      return left(e.toFirestoreRemoteStorageEx());
    }
  }

  @override
  Future<Either<CoreException, String>> putBlob({
    required dynamic blob,
    required String path,
    StorageMetadata? metadata,
  }) async {
    try {
      return await _storage
          .ref()
          .child(path)
          .putBlob(
            blob,
            metadata?.toSettableMetaData,
          )
          .then((snapShot) async => right(await snapShot.ref.getDownloadURL()));
    } on FirebaseException catch (e) {
      return left(e.toFirestoreRemoteStorageEx());
    }
  }

  @override
  Future<Either<CoreException, String>> putData({
    required Uint8List data,
    required String path,
    StorageMetadata? metadata,
  }) async {
    try {
      return await _storage
          .ref()
          .child(path)
          .putData(
            data,
            metadata?.toSettableMetaData,
          )
          .then((snapShot) async => right(await snapShot.ref.getDownloadURL()));
    } on FirebaseException catch (e) {
      return left(e.toFirestoreRemoteStorageEx());
    }
  }

  @override
  Future<Either<CoreException, String>> putString({
    required String data,
    required String path,
    StorageMetadata? metadata,
  }) async {
    try {
      return await _storage
          .ref()
          .child(path)
          .putString(
            data,
            metadata: metadata?.toSettableMetaData,
          )
          .then((snapShot) async => right(await snapShot.ref.getDownloadURL()));
    } on FirebaseException catch (e) {
      return left(e.toFirestoreRemoteStorageEx());
    }
  }

  @override
  Future<Option<CoreException>> writeToFile({
    required File file,
    required String path,
  }) async {
    try {
      return await _storage
          .ref()
          .child(path)
          .writeToFile(file)
          .then((_) => none());
    } on FirebaseException catch (e) {
      return some(e.toFirestoreRemoteStorageEx());
    }
  }

  @override
  Future<Either<CoreException, String>> putFile({
    required File file,
    required String path,
    StorageMetadata? metadata,
  }) async {
    try {
      return await _storage
          .ref()
          .child(path)
          .putFile(file, metadata?.toSettableMetaData)
          .then((snapshot) async => right(await snapshot.ref.getDownloadURL()));
    } on FirebaseException catch (e) {
      return left(e.toFirestoreRemoteStorageEx());
    }
  }
}
