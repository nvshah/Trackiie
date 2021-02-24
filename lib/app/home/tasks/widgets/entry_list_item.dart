import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/tasks/models/entry.dart';
import 'package:time_tracker/app/home/tasks/models/entry_list_item_model.dart';
import 'package:time_tracker/app/home/tasks/models/task_model.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    //@required this.entry,
    //@required this.task,
    @required this.onTap,
    @required this.model,
  });

  //final Entry entry;
  //final Task task;
  final VoidCallback onTap;
  final EntryListItemModel model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final startTimeLocalized = model.startTime.format(context);
    final endTimeLocalized = model.endTime.format(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(
            model.dayOfWeek,
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
          ),
          SizedBox(width: 15.0),
          Text(
            model.startDate,
            style: TextStyle(fontSize: 18.0),
          ),
          if (model.task.ratePerHour > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              model.payFormatted,
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          Text(
            '$startTimeLocalized - $endTimeLocalized',
            style: TextStyle(fontSize: 16.0),
          ),
          Expanded(child: Container()),
          Text(
            model.durationFormatted,
            style: TextStyle(fontSize: 16.0),
          ),
        ]),
        if (model.entry.comment.isNotEmpty)
          Text(
            model.entry.comment,
            style: TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    this.key,
    this.entry,
    this.task,
    this.onDismissed,
    this.onTap,
  });

  final Key key;
  final Entry entry;
  final Task task;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: EntryListItem(
        //entry: entry,
        //task: task,
        model: EntryListItemModel(entry: entry, task: task),
        onTap: onTap,
      ),
    );
  }
}
