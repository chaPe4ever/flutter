import 'package:core/core.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Sealed Firestore types need lightweight fakes for map validation tests.
// ignore_for_file: subtype_of_sealed_class

final class _NonMapSnapshot implements DocumentSnapshot<Object?> {
  @override
  Object? data() => 42;

  @override
  bool get exists => true;

  @override
  String get id => 'bad';

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  DocumentReference<Object?> get reference => _FakeDocRef();

  @override
  dynamic get(Object field) => throw UnimplementedError();

  @override
  dynamic operator [](Object field) => throw UnimplementedError();
}

final class _FakeDocRef implements DocumentReference<Object?> {
  @override
  CollectionReference<Object?> get parent => _FakeCollectionRef();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeCollectionRef implements CollectionReference<Object?> {
  @override
  String get id => 'users';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('DocumentSnapshotX', () {
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
    });

    test('getDataOrCrash returns data when document exists', () async {
      await firestore.collection('users').doc('u1').set({'name': 'Ada'});
      final snapshot = await firestore.collection('users').doc('u1').get();

      expect(snapshot.getDataOrCrash(), {'name': 'Ada'});
    });

    test('getDataOrCrash throws when document is missing', () async {
      final snapshot = await firestore.collection('users').doc('missing').get();

      expect(
        snapshot.getDataOrCrash,
        throwsA(isA<FirestoreNullDocumentSnapshotException>()),
      );
    });

    test('requireFirestoreDocumentJsonMap throws when data is not a map', () {
      expect(
        () => requireFirestoreDocumentJsonMap(snapshot: _NonMapSnapshot()),
        throwsA(isA<FirestoreNullDocumentSnapshotException>()),
      );
    });

    test('fromJsonOrCrash injects id and maps json', () async {
      await firestore.collection('users').doc('u2').set({'name': 'Bob'});
      final snapshot = await firestore.collection('users').doc('u2').get();

      final model = snapshot.fromJsonOrCrash(_UserModel.fromJson);

      expect(model.id, 'u2');
      expect(model.name, 'Bob');
    });
  });

  group('QuerySnapshotX', () {
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
    });

    test('getDataList and sorted return document data', () async {
      await firestore.collection('items').doc('a').set({'n': 2});
      await firestore.collection('items').doc('b').set({'n': 1});
      final snapshot = await firestore.collection('items').get();

      expect(snapshot.getDataList().length, 2);
      expect(
        snapshot
            .getDataListSortBy(
              (a, b) => (a['n'] as int).compareTo(b['n'] as int),
            )
            .first['n'],
        1,
      );
    });

    test('getFirstRefOrCrash and getFirstFromDataListOrCrash', () async {
      await firestore.collection('items').doc('only').set({'n': 1});
      final snapshot = await firestore.collection('items').get();

      expect(snapshot.getFirstRefOrCrash().id, 'only');
      expect(snapshot.getFirstFromDataListOrCrash()['n'], 1);
    });

    test('getFirst helpers throw when query is empty', () async {
      final snapshot = await firestore.collection('empty').get();

      expect(
        snapshot.getFirstRefOrCrash,
        throwsA(isA<FirestoreNullDocumentSnapshotException>()),
      );
      expect(
        snapshot.getFirstFromDataListOrCrash,
        throwsA(isA<FirestoreNullDocumentSnapshotException>()),
      );
    });
  });

  group('AsyncSnapshotX', () {
    testWidgets('when shows data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              const snapshot = AsyncSnapshot<String>.withData(
                ConnectionState.done,
                'hello',
              );
              return snapshot.when(
                data: Text.new,
                err: (_) => const Text('err'),
              );
            },
          ),
        ),
      );
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('when shows error widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final snapshot = AsyncSnapshot<String>.withError(
                ConnectionState.done,
                Exception('fail'),
                StackTrace.current,
              );
              return snapshot.when(
                data: Text.new,
                err: (_) => const Text('err'),
              );
            },
          ),
        ),
      );
      expect(find.text('err'), findsOneWidget);
    });

    testWidgets('when shows default empty on error without handler', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final snapshot = AsyncSnapshot<String>.withError(
                ConnectionState.done,
                Exception('fail'),
                StackTrace.current,
              );
              return snapshot.when(
                data: Text.new,
                err: null,
              );
            },
          ),
        ),
      );
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('when shows loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              const snapshot = AsyncSnapshot<String>.nothing();
              return snapshot.when(
                data: Text.new,
                err: (_) => const Text('err'),
                loading: const Text('loading'),
              );
            },
          ),
        ),
      );
      expect(find.text('loading'), findsOneWidget);
    });
  });
}

final class _UserModel {
  const _UserModel({required this.id, required this.name});

  factory _UserModel.fromJson(Map<String, dynamic> json) => _UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
  );

  final String id;
  final String name;
}
