import 'package:time_tracker/app/home/tasks/models/task_model.dart';
import 'package:time_tracker/services/api_data.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createTask(Task data);
  Stream<List<Task>> tasksStream();
}

class FireStoreDatabase extends Database {
  final String uid;
  FireStoreDatabase({this.uid});

  final fireStoreService = FireStoreService.I;

  ///Create task document for user in FireStore
  @override
  Future<void> createTask(Task data) async => fireStoreService.setData(
      path: ApiData.pathToTask(uid, 'job_abc'), data: data.toMap());
  //location where we want to write in firestore

  ///Get Stream of task from collection -> tasks under userDoc from Firestore
  Stream<List<Task>> tasksStream() => fireStoreService.collectionStream<Task>(
        path: ApiData.pathToTasks(uid),
        builder: (data) => Task.fromMap(data),
      );
}
