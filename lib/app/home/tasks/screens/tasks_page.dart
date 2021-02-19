import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/auth.dart';
import '../../../../services/database.dart';
import '../../../../widgets/platform_alert_dialog.dart';
import '../models/task_model.dart';
import '../widgets/list_items_builder.dart';
import '../widgets/task_list_tile.dart';
import 'task_details_page.dart';

class TasksPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  ///Takes consent from user for sign out
  Future<void> _confirmSignout(BuildContext context) async {
    final doSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure ?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);

    //perfrom logout
    if (doSignOut == true) {
      _signOut(context);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
            ),
            onPressed: () => _confirmSignout(context),
          ),
        ],
      ),
      body: _buildBody(context),
      //NEW TASK
      floatingActionButton: FloatingActionButton(
        onPressed: () => TaskDetailsPage.show(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final db = Provider.of<Database>(context);
    return StreamBuilder<List<Task>>(
        stream: db.tasksStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<Task>(
            snapshot: snapshot,
            itemBuilder: (context, task) => TaskListLitle(
              task: task,
              onTap: () => TaskDetailsPage.show(context, task: task),
            ),
          );
        });
  }
}
