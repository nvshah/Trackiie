import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_tracker/app/home/entries/model/daily_tasks_details.dart';
import 'package:time_tracker/app/home/entries/model/entry_task.dart';
import 'package:time_tracker/app/home/entries/widgets/entries_list_tile.dart';
import 'package:time_tracker/app/home/tasks/models/entry.dart';
import 'package:time_tracker/app/home/tasks/models/task_model.dart';
import 'package:time_tracker/utils/format.dart';
import 'package:time_tracker/services/database.dart';

class EntriesBloc {
  EntriesBloc({@required this.database});
  final Database database;

  /// combine List<Task>, List<Entry> into List<EntryTask>
  /// Multiple Indepenedent Streams -> 1 Output Stream
  Stream<List<EntryTask>> get _allEntriesStream => Observable.combineLatest2(
        database.entriesStream(),
        database.tasksStream(),
        _entriesJobsCombiner,
      );

  static List<EntryTask> _entriesJobsCombiner(
      List<Entry> entries, List<Task> jobs) {
    return entries.map((entry) {
      final job = jobs.firstWhere((job) => job.id == entry.taskId);
      return EntryTask(entry, job);
    }).toList();
  }

  /// Output stream
  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryTask> allEntries) {
    final allDailyJobsDetails = DailyTasksDetails.all(allEntries);

    // total duration across all jobs
    final totalDuration = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.duration)
        .reduce((value, element) => value + element);

    // total pay across all jobs
    final totalPay = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.pay)
        .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      //1st Row i.e Header
      EntriesListTileModel(
        leadingText: 'All Entries',
        middleText: Format.currency(totalPay),
        trailingText: Format.hours(totalDuration),
      ),
      //Data :-
      for (DailyTasksDetails dailyTasksDetails in allDailyJobsDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyTasksDetails.date),
          middleText: Format.currency(dailyTasksDetails.pay),
          trailingText: Format.hours(dailyTasksDetails.duration),
        ),
        for (TaskDetails jobDuration in dailyTasksDetails.tasksDetails)
          EntriesListTileModel(
            leadingText: jobDuration.name,
            middleText: Format.currency(jobDuration.pay),
            trailingText: Format.hours(jobDuration.durationInHours),
          ),
      ]
    ];
  }
}
