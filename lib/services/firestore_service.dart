import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreService {
  FireStoreService._();
  static final FireStoreService I = FireStoreService._();

  ///Set document data at specified collection path
  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final ref = Firestore.instance.document(path);
    print('$path: $data'); //logging purpose
    await ref.setData(data);
  }

  ///Helper method on Generic type T : provider stream of T doc from collection at given path
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    //collection path
    final ref = Firestore.instance.collection(path);
    final snaps = ref.snapshots(); //snapshot of collections
    return snaps.map(
      //snap of collection at given time in firestore
      (snap) => snap.documents.map((doc) => builder(doc.data)).toList(),
    );
  }
}
