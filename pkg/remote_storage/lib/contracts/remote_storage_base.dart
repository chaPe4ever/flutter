import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:remote_storage/models/storage_meta_data.dart';

///
abstract interface class RemoteStorageBase {
  /// The name of the bucket containing this reference's object.
  String get bucket;

  /// The full path of this object.
  String get fullPath;

  /// The short name of this object, which is the last component of the full
  /// path.
  ///
  /// For example, if fullPath is 'full/path/image.png', name is 'image.png'.
  String get name;

  /// Deletes the object at this reference's location.  it might return
  /// a [CoreException] if the process fails
  ///
  /// Might throw [CoreException]
  Future<Option<CoreException>> delete({required String path});

  /// Fetches a long lived download URL for this object.
  ///
  /// Might throw [CoreException]
  Future<Either<CoreException, String>> getDownloadURL({required String path});

  /// Asynchronously downloads the object at the StorageReference to a list in
  /// memory.
  ///
  /// Returns a [Uint8List] of the data.
  ///
  /// If the [maxSize] (in bytes) is exceeded, the operation will be canceled.
  /// By default the [maxSize] is 10mb (10485760 bytes).
  ///
  /// Might throw [CoreException]
  Future<Either<CoreException, Uint8List?>> getData({
    required String path,
    int maxSize = 10485760,
  });

  /// Uploads data to this reference's location.  it returns
  /// either the downloadableFileUrl or a [CoreException]
  ///
  /// Use this method to upload fixed sized data as a [Uint8List].
  ///
  /// Optionally, you can also set metadata onto the uploaded object.
  Future<Either<CoreException, String>> putData({
    required Uint8List data,
    required String path,
    StorageMetadata? metadata,
  });

  /// Upload a Blob. Note: this is only supported on web platforms.  it returns
  /// either the downloadableFileUrl or a [CoreException]
  ///
  /// Optionally, you can also set metadata onto the uploaded object.
  ///
  /// Might throw [CoreException]
  Future<Either<CoreException, String>> putBlob({
    required dynamic blob,
    required String path,
    StorageMetadata? metadata,
  });

  /// Upload a [String] value as a storage object.  it returns
  /// either the downloadableFileUrl or a [CoreException]
  ///
  /// Might throw [CoreException]
  Future<Either<CoreException, String>> putString({
    required String data,
    required String path,
    StorageMetadata? metadata,
  });

  /// Upload a [File] from the filesystem. The file must exist. it returns
  /// either the downloadableFileUrl or a [CoreException]
  ///
  /// Optionally, you can also set metadata onto the uploaded object.
  Future<Either<CoreException, String>> putFile({
    required File file,
    required String path,
    StorageMetadata? metadata,
  });

  /// Writes a remote storage object to the local filesystem. it might return
  /// a [CoreException] if the process fails
  ///
  /// If a file already exists at the given location, it will be overwritten.
  ///
  /// Might throw [CoreException]
  Future<Option<CoreException>> writeToFile({
    required File file,
    required String path,
  });
}
