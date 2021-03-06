import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:time_tracker/services/auth.dart';

import 'package:time_tracker/widgets/platform_alert_dialog.dart';

class AccountPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        actions: <Widget>[
          //LOGOUT
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () => _confirmSignout(context),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
