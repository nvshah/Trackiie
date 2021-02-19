import 'package:flutter/material.dart';

import '../app/home/tasks/models/task_model.dart';
import 'api_data.dart';
import 'firestore_service.dart';

abstract class Database {
  Stream<List<Task>> tasksStream();
  Future<void> setTask(Task task);
  Future<void> deleteTask(Task task);
}

class FireStoreDatabase extends Database {
  final String uid;
  FireStoreDatabase({@required this.uid});

  final fireStoreService = FireStoreService.I;

  String get _getDocumentId => DateTime.now().toIso8601String();

  ///Get Stream of task from collection -> tasks under userDoc from Firestore
  Stream<List<Task>> tasksStream() => fireStoreService.collectionStream<Task>(
        path: ApiData.pathToTasks(uid),
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
}
