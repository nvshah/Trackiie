import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/home/entries/model/entry_task.dart';

/// Temporary model class to store the time tracked and pay for a task
class TaskDetails {
  TaskDetails({
    @required this.name,
    @required this.durationInHours,
    @required this.pay,
  });
  final String name;
  double durationInHours;
  double pay;
}

/// Groups together all tasks/entries on a given day
class DailyTasksDetails {
  DailyTasksDetails({@required this.date, @required this.tasksDetails});
  final DateTime date;
  final List<TaskDetails> tasksDetails;

  double get pay => tasksDetails
      .map((taskDuration) => taskDuration.pay)
      .reduce((value, element) => value + element);

  double get duration => tasksDetails
      .map((taskDuration) => taskDuration.durationInHours)
      .reduce((value, element) => value + element);

  /// splits all entries into separate groups by date
  static Map<DateTime, List<EntryTask>> _entriesByDate(
      List<EntryTask> entries) {
    Map<DateTime, List<EntryTask>> map = {};
    for (var entryTask in entries) {
      final entryDayStart = DateTime(entryTask.entry.start.year,
          entryTask.entry.start.month, entryTask.entry.start.day);
      if (map[entryDayStart] == null) {
        map[entryDayStart] = [entryTask];
      } else {
        map[entryDayStart].add(entryTask);
      }
    }
    return map;
  }

  /// maps an unordered list of EntryTask into a list of DailyTasksDetails with date information
  static List<DailyTasksDetails> all(List<EntryTask> entries) {
    final byDate = _entriesByDate(entries);
    List<DailyTasksDetails> list = [];
    for (var date in byDate.keys) {
      final entriesByDate = byDate[date];
      final byJob = _tasksDetails(entriesByDate);
      list.add(DailyTasksDetails(date: date, tasksDetails: byJob));
    }
    return list.toList();
  }

  /// groups entries by task
  static List<TaskDetails> _tasksDetails(List<EntryTask> entries) {
    Map<String, TaskDetails> taskDuration = {};
    for (var entryTask in entries) {
      final entry = entryTask.entry;
      final pay = entry.durationInHours * entryTask.task.ratePerHour;
      if (taskDuration[entry.taskId] == null) {
        taskDuration[entry.taskId] = TaskDetails(
          name: entryTask.task.name,
          durationInHours: entry.durationInHours,
          pay: pay,
        );
      } else {
        taskDuration[entry.taskId].pay += pay;
        taskDuration[entry.taskId].durationInHours += entry.durationInHours;
      }
    }
    return taskDuration.values.toList();
  }
}
