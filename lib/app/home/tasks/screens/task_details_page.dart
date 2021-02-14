import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/tasks/models/task_model.dart';
import 'package:time_tracker/services/database.dart';
import 'package:time_tracker/widgets/platform_alert_dialog.dart';
import 'package:time_tracker/widgets/platform_exception_alert_dialog.dart';

class TaskDetailsPage extends StatefulWidget {
  final Database db;
  final Task task;

  TaskDetailsPage({Key key, @required this.db, this.task}) : super(key: key);

  ///this method will do all stuff from getting navigator & pushing itself on Page stack
  static Future<void> show(BuildContext context, {Task task}) async {
    final db = Provider.of<Database>(context);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => TaskDetailsPage(
        db: db,
        task: task,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<TaskDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _rate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _name = widget.task.name;
      _rate = widget.task.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submitForm() async {
    if (_validateAndSaveForm()) {
      try {
        // print('Form Saved, name:$_name, rate:$_rate');
        final tasksAtRemote = await widget.db.tasksStream().first;
        final allNames = tasksAtRemote.map((t) => t.name).toList();
        //Allow repeating of task name when editing the task
        //exclude current name from list of existing task
        if (widget.task != null) {
          allNames.remove(widget.task.name);
        }
        //task name must be unique
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already exists',
            content: 'Please select different task name !',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final task =
              Task(id: widget.task?.id, name: _name, ratePerHour: _rate);
          await widget.db.setTask(task);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(title: 'Operation failed', exception: e)
            .show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        elevation: 2.0,
        actions: <Widget>[
          //SAVE FORM
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // child: Placeholder(
          //   fallbackHeight: 200,
          // ),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //NAME
          TextFormField(
            decoration: InputDecoration(labelText: 'Task Name'),
            onSaved: (v) => _name = v,
            validator: (v) => v.isNotEmpty ? null : "Input can't be empty",
            initialValue: _name,
          ),
          //RATE
          TextFormField(
            decoration: InputDecoration(labelText: 'Rate Per Hour'),
            keyboardType: TextInputType.numberWithOptions(
              decimal: false,
              signed: false,
            ),
            onSaved: (v) => _rate = int.tryParse(v) ?? 0,
            initialValue: '${_rate ?? ''}',
          )
        ],
      ),
    );
  }
}

// class _TaskForm extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           // child: Placeholder(
//           //   fallbackHeight: 200,
//           // ),
//           child: Form(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               //NAME
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Task Name'),
//                 onSaved: (v) => _name = ,
//               ),
//               //RATE
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Rate Per Hour'),
//                 keyboardType: TextInputType.numberWithOptions(
//                   decimal: false,
//                   signed: false,
//                 ),
//               )
//             ],
//           )),
//         ),
//       ),
//     );
//   }
// }
