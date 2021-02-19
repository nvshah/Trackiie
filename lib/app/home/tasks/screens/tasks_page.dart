import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/tasks/screens/task_details_page.dart';
import 'package:time_tracker/app/home/tasks/widgets/empty_content.dart';
import 'package:time_tracker/app/home/tasks/widgets/task_list_tile.dart';

import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/widgets/platform_alert_dialog.dart';

import 'package:time_tracker/app/home/tasks/models/task_model.dart';

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
          if (snapshot.hasData) {
            final tasks = snapshot.data;
            //Empty Content
            if (tasks.isEmpty) {
              return EmptyContent();
            }
            final children = tasks
                .map(
                  (t) => TaskListLitle(
                    task: t,
                    onTap: () =>
                        TaskDetailsPage.show(context, task: t), //edit task
                  ),
                )
                .toList();
            return ListView(
              children: children,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Some Error Occured'),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
