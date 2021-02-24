import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreService {
  FireStoreService._();
  static final FireStoreService I = FireStoreService._();

  ///Set document data at specified collection path
  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final ref = Firestore.instance.document(path);
    print('$path: $data'); //logging purpose
    await ref.setData(data);
  }

  ///Delete document data at specified collection path
  Future<void> deleteData({@required String path}) async {
    final ref = Firestore.instance.document(path);
    print('delete: $path'); //logging purpose
    await ref.delete();
  }

  ///Helper method on Generic type T : provider stream of T doc from collection at given path
  ///path - path to collection
  ///builder - get data & docId for each document present in collection at moment
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(String id, Map<String, dynamic> data),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    //collection path
    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    // final ref = Firestore.instance.collection(path);
    final snaps = query.snapshots(); //snapshot of collections
    return snaps.map((snap) {
      //snap of collection at given time in firestore
      final result = snap.documents
          .map((doc) => builder(doc.documentID, doc.data))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    @required
        String path,
    @required
        T builder(
      String documentID,
      Map<String, dynamic> data,
    ),
  }) {
    final DocumentReference reference = Firestore.instance.document(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(
          snapshot.documentID,
          snapshot.data,
        ));
  }
}
