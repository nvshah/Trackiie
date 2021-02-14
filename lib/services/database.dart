import 'package:time_tracker/app/home/tasks/models/task_model.dart';
import 'package:time_tracker/services/api_data.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Stream<List<Task>> tasksStream();
  Future<void> setTask(Task task);
}

class FireStoreDatabase extends Database {
  final String uid;
  FireStoreDatabase({this.uid});

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
}
