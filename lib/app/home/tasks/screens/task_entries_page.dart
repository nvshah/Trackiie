import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/app/home/tasks/widgets/entry_list_item.dart';
import 'package:time_tracker/app/home/tasks/screens/entry_page.dart';
import 'package:time_tracker/app/home/tasks/models/entry.dart';
import 'package:time_tracker/app/home/tasks/models/task_model.dart';
import 'package:time_tracker/app/home/tasks/screens/task_details_page.dart';
import 'package:time_tracker/app/home/tasks/widgets/list_items_builder.dart';

import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/widgets/platform_exception_alert_dialog.dart';

class TaskEntriesPage extends StatelessWidget {
  const TaskEntriesPage({@required this.database, @required this.task});
  final Database database;
  final Task task;

  static Future<void> show(BuildContext context, Task task) async {
    final Database database = Provider.of<Database>(context);
    //NOTE : here Navigator of HomePage is referred
    // and when we pop this page in view default behaviour of back button must be restored
    await Navigator.of(context).push(
      //For parallex effect
      CupertinoPageRoute(
        fullscreenDialog: false, //page sliding from right & back button on ios
        builder: (context) => TaskEntriesPage(database: database, task: task),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //inorder to update task details back & Forth reactively
    return StreamBuilder<Task>(
        stream: database.taskStream(task.id),
        builder: (context, snapshot) {
          final task = snapshot.data;
          final taskName = task?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(taskName),
              centerTitle: true,
              actions: <Widget>[
                //EDIT ENTRY
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                    //size: 18,
                  ),
                  onPressed: () =>
                      TaskDetailsPage.show(context, database, task: task),
                ),
                //NEW ENTRY
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () => EntryPage.show(
                    context: context,
                    database: database,
                    task: task,
                  ),
                ),
              ],
            ),
            body: _buildContent(context, task),
          );
        });
  }

  Widget _buildContent(BuildContext context, Task task) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(task: task),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              task: task,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                task: task,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
