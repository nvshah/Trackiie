import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/tasks/models/entry.dart';

import '../app/home/tasks/models/task_model.dart';
import 'api_data.dart';
import 'firestore_service.dart';

abstract class Database {
  Stream<List<Task>> tasksStream();
  Future<void> setTask(Task task);
  Future<void> deleteTask(Task task);
  Stream<Task> taskStream(String tid);

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Task task});
}

class FireStoreDatabase extends Database {
  final String uid;
  FireStoreDatabase({@required this.uid});

  final fireStoreService = FireStoreService.I;

  String get _getDocumentId => DateTime.now().toIso8601String();

  ///Get Stream of tasks from collection -> tasks under userDoc from Firestore
  @override
  Stream<List<Task>> tasksStream() => fireStoreService.collectionStream<Task>(
        path: ApiData.pathToTasks(uid),
        builder: (id, data) => Task.fromMap(id, data),
      );

  ///Get Stream of task from collection -> task under userDoc/tasks from Firestore
  @override
  Stream<Task> taskStream(String tid) => fireStoreService.documentStream<Task>(
        path: ApiData.pathToTask(uid, tid),
        builder: (id, data) => Task.fromMap(id, data),
      );

  //Create or Modify Task
  @override
  Future<void> setTask(Task task) async => fireStoreService.setData(
        path: ApiData.pathToTask(
          uid,
          task.id ?? _getDocumentId,
        ), //location where we want to write in firestore
        data: task.toMap(),
      );

  //Delete Task
  @override
  Future<void> deleteTask(Task task) async => fireStoreService.deleteData(
        path: ApiData.pathToTask(
          uid,
          task.id,
        ), //location where we want to write in firestore
      );

  @override
  Future<void> setEntry(Entry entry) async => await fireStoreService.setData(
        path: ApiData.pathToEntry(
          uid,
          entry.id ?? _getDocumentId,
        ),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) async => await fireStoreService
      .deleteData(path: ApiData.pathToEntry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Task task}) =>
      fireStoreService.collectionStream<Entry>(
        path: ApiData.pathToEntries(uid),
        queryBuilder: task != null
            ? (query) => query.where('taskId', isEqualTo: task.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(documentID, data),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
