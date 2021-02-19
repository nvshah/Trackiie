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
  }) {
    //collection path
    final ref = Firestore.instance.collection(path);
    final snaps = ref.snapshots(); //snapshot of collections
    return snaps.map(
      //snap of collection at given time in firestore
      (snap) => snap.documents
          .map((doc) => builder(doc.documentID, doc.data))
          .toList(),
    );
  }
}
