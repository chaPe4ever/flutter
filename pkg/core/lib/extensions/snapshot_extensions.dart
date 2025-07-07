// ignore_for_file: null_check_on_nullable_type_parameter
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
      return data(this.data!);
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
    (final snapshot) when snapshot.existsAndDataNotNull => snapshot.data()!,
    (_) => throw FirestoreNullDocumentSnapshotException(
      innerMessage:
          'The snapshot: $this does not exist or it is null | ID: $id | parrent ID: ${reference.parent.id}',
    ),
  };

  T fromJsonOrCrash<T>(T Function(Map<String, dynamic> json) fromJson) {
    return switch (this) {
      (final snapshot) when snapshot.existsAndDataNotNull => fromJson(
        (snapshot.data()! as Map<String, dynamic>)
          ..update('id', (_) => id, ifAbsent: () => id),
      ),
      (_) => throw FirestoreNullDocumentSnapshotException(
        innerMessage:
            'The snapshot: $this does not exist or it is null | | ID: $id | parrent ID: ${reference.parent.id}',
      ),
    };
  }
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
          "The document: $this doesn't exist or it's' null | ID: ${docs.firstOrNull?.id}",
    ),
  };

  T getFirstFromDataListOrCrash() => switch (this) {
    (final snapshot) when snapshot.docs.firstOrNull != null =>
      snapshot.docs.first.data()!,
    (_) => throw FirestoreNullDocumentSnapshotException(
      innerMessage:
          'The snapshot: $this found null | ID: ${docs.firstOrNull?.id}',
    ),
  };
}
