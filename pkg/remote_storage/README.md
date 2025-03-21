This package makes use of the firebase storage API wrapped around Riverpod

## Features

- GetDownloadURL
- getData
- putData
- putBlob
- putString
- putFile
- writeToFile

## Getting started

Assuming you have registered your project and you have already the `firebase_options` in place, 
then initialise the firebase:

```dart
main(){
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    ...
}
```

## Usage

```dart
...
@override
Widget build(BuildContext context, WidgetRef ref) {
    final getData = ref.read(remoteStoragePod).getData(path: 'path_of_remote_stirage_data');
}
```

## Additional information

The current API is:

```dart
  /// Deletes the object at this reference's location. 
  Future<Option<CoreException>> delete({required String path});

  /// Fetches a long lived download URL for this object.
  Future<Either<CoreException, String>> getDownloadURL({required String path});

  /// Asynchronously downloads the object at the StorageReference to a list in
  /// memory.
  ///
  /// Returns a [Uint8List] of the data.
  ///
  /// If the [maxSize] (in bytes) is exceeded, the operation will be canceled.
  /// By default the [maxSize] is 10mb (10485760 bytes).
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
  Future<Either<CoreException, String>> putBlob({
    required dynamic blob,
    required String path,
    StorageMetadata? metadata,
  });

  /// Upload a [String] value as a storage object.  it returns
  /// either the downloadableFileUrl or a [CoreException]
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
  Future<Option<CoreException>> writeToFile({
    required File file,
    required String path,
  });
```


## Tranlsation keys

- firebase_remote_storage_exception_message_key