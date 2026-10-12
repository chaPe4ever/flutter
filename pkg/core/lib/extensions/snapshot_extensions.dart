import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/exceptions/core_exceptions.dart';
import 'package:core/extensions/primitive_types_extensions.dart';
import 'package:flutter/material.dart';

extension AsyncSnapshotX<T> on AsyncSnapshot<T> {
  Widget when({
    required Widget Function(T) data,
    required Widget Function(Object)? err,
    Widget loading = const CircularProgressIndicator(),
  }) {
    if (hasData) {
      return data(this.data as T);
    } else if (hasError) {
      return err?.call(error!) ?? const SizedBox();
    } else {
      return loading;
    }
  }
}

extension DocumentSnapshotX<T extends Object?> on DocumentSnapshot<T> {
  bool get existsAndDataNotNull => exists && data() != null;

  T getDataOrCrash() => switch (this) {
    (final snapshot) when snapshot.existsAndDataNotNull => snapshot.data() as T,
    (_) => throw FirestoreNullDocumentSnapshotException(
      innerMessage:
          'The snapshot: $this does not exist or it is null | '
          'ID: $id | parrent ID: ${reference.parent.id}',
    ),
  };

  R fromJsonOrCrash<R>(R Function(Map<String, dynamic> json) fromJson) {
    final jsonMap = requireFirestoreDocumentJsonMap(snapshot: this);
    return fromJson(jsonMap..update('id', (_) => id, ifAbsent: () => id));
  }
}

/// Validates [snapshot] data is a non-null JSON map
/// (testable without Firestore).
Map<String, dynamic> requireFirestoreDocumentJsonMap<T>({
  required DocumentSnapshot<T> snapshot,
}) {
  final snapshotData = snapshot.data();
  if (!snapshot.existsAndDataNotNull || snapshotData is! Map<String, dynamic>) {
    throw FirestoreNullDocumentSnapshotException(
      innerMessage:
          'The snapshot: $snapshot does not exist or it is null | | '
          'ID: ${snapshot.id} | parrent ID: ${snapshot.reference.parent.id}',
    );
  }
  return snapshotData;
}

extension QuerySnapshotX<T extends Object?> on QuerySnapshot<T> {
  List<T> getDataListSortBy(int Function(T a, T b) compare) =>
      getDataList().sorted(compare);

  List<T> getDataList() => docs.map((e) => e.data()).toList();

  DocumentReference<T> getFirstRefOrCrash() => switch (this) {
    (final snapshot) when snapshot.docs.firstOrNull != null =>
      snapshot.docs.first.reference,
    (_) => throw FirestoreNullDocumentSnapshotException(
      innerMessage:
          "The document: $this doesn't exist or it's' null | "
          'ID: ${docs.firstOrNull?.id}',
    ),
  };

  T getFirstFromDataListOrCrash() => switch (this) {
    (final snapshot) when snapshot.docs.firstOrNull != null =>
      snapshot.docs.first.data(),
    (_) => throw FirestoreNullDocumentSnapshotException(
      innerMessage:
          'The snapshot: $this found null | ID: ${docs.firstOrNull?.id}',
    ),
  };
}
