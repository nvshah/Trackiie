import 'dart:core';

class ApiData {
  static String pathToTask(String uid, String taskId) =>
      'users/$uid/tasks/$taskId';
  static String pathToTasks(String uid) => 'users/$uid/tasks';
}
