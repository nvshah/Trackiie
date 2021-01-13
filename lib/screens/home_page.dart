import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/platform_aware_dialog.dart';

import '../services/auth.dart';

class HomePage extends StatelessWidget {
  final AuthBase auth;

  HomePage({
    @required this.auth,
  });

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  ///Takes consent from user for sign out
  Future<void> _confirmSignout(BuildContext context) async {
    final doSignOut = await PlatformAwareDialog(
      title: 'Logout',
      content: 'Are you sure ?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);

    //perfrom logout
    if (doSignOut == true) {
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
            ),
            onPressed: () => _confirmSignout(context),
          ),
        ],
      ),
    );
  }
}
