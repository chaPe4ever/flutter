import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_storage/implementations/fake_remote_storage_impl.dart';
import 'package:remote_storage/models/storage_meta_data.dart';

void main() {
  const impl = FakeRemoteStorageImpl(
    bucket: 'bucket-a',
    fullPath: 'root/object',
    name: 'object',
  );

  test('exposes configured reference properties', () {
    expect(impl.bucket, 'bucket-a');
    expect(impl.fullPath, 'root/object');
    expect(impl.name, 'object');
  });

  test('delete succeeds without an error', () async {
    final result = await impl.delete(path: 'avatars/user.png');

    expect(result.isNone(), isTrue);
  });

  test('getDownloadURL returns a fake download url', () async {
    final result = await impl.getDownloadURL(path: 'avatars/user.png');

    expect(
      result,
      right<CoreException, String>('https://fake.storage/avatars/user.png'),
    );
  });

  test('getData returns null bytes', () async {
    final result = await impl.getData(path: 'avatars/user.png');

    expect(result, right<CoreException, Uint8List?>(null));
  });

  test('upload helpers return fake download urls', () async {
    final metadata = StorageMetadata(contentType: 'text/plain');
    final file = File('fake_remote_storage_impl_test.txt');
    addTearDown(() {
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    expect(
      await impl.putData(
        data: Uint8List.fromList([1, 2, 3]),
        path: 'data.bin',
        metadata: metadata,
      ),
      right<CoreException, String>('https://fake.storage/data.bin'),
    );
    expect(
      await impl.putString(
        data: 'hello',
        path: 'hello.txt',
        metadata: metadata,
      ),
      right<CoreException, String>('https://fake.storage/hello.txt'),
    );
    expect(
      await impl.putBlob(
        blob: Object(),
        path: 'blob.bin',
        metadata: metadata,
      ),
      right<CoreException, String>('https://fake.storage/blob.bin'),
    );
    expect(
      await impl.putFile(
        file: file,
        path: 'file.bin',
        metadata: metadata,
      ),
      right<CoreException, String>('https://fake.storage/file.bin'),
    );
  });

  test('writeToFile succeeds without an error', () async {
    final file = File('fake_remote_storage_write_test.txt');
    addTearDown(() {
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    final result = await impl.writeToFile(
      file: file,
      path: 'downloads/file.bin',
    );

    expect(result.isNone(), isTrue);
  });
}
