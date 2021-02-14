import 'package:flutter/material.dart';

import 'package:time_tracker/app/home/tasks/models/task_model.dart';

class TaskListLitle extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  TaskListLitle({Key key, @required this.task, @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('task.name'),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
