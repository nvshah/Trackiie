import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/tasks/screens/task_entries_page.dart';
import 'package:time_tracker/widgets/platform_exception_alert_dialog.dart';

import '../../../../services/database.dart';
import '../models/task_model.dart';
import '../widgets/list_items_builder.dart';
import '../widgets/task_list_tile.dart';
import 'task_details_page.dart';

class TasksPage extends StatelessWidget {
  // void _createTask(BuildContext ctxt) {
  //   try {
  //     final db = Provider.of<Database>(ctxt);
  //     db.createTask(Task(
  //       name: 'Gaming',
  //       ratePerHour: 20,
  //     ));
  //   } on PlatformException catch (e) {
  //     PlatformExceptionAlertDialog(title: 'Operation Failed', exception: e)
  //         .show(ctxt);
  //   }
  // }

  Future<void> _deleteHandler(BuildContext context, Task task) async {
    try {
      final db = Provider.of<Database>(context);
      await db.deleteTask(task);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: <Widget>[
          //NEW TASK
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => TaskDetailsPage.show(
              context,
              Provider.of<Database>(context),
            ),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final db = Provider.of<Database>(context);
    return StreamBuilder<List<Task>>(
        stream: db.tasksStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<Task>(
            snapshot: snapshot,
            itemBuilder: (context, task) => Dismissible(
              //key is required while using Dismissible
              key: Key('task_${task.id}'), //key must be unique
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => _deleteHandler(context, task),
              child: TaskListLitle(
                task: task,
                onTap: () => TaskEntriesPage.show(context, task),
              ),
            ),
          );
        });
  }
}
