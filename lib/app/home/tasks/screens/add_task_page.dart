import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  ///this method will do all stuff from getting navigator & pushing itself on Page stack
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AddTaskPage(),
      fullscreenDialog: true,
    ));
  }

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: _TaskForm(),
      ),
    );
  }
}

class _TaskForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // child: Placeholder(
          //   fallbackHeight: 200,
          // ),
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //NAME
              TextFormField(
                decoration: InputDecoration(labelText: 'Task Name'),
              ),
              //RATE
              TextFormField(
                decoration: InputDecoration(labelText: 'Rate Per Hour'),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: false,
                  signed: false,
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
