import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/account/widgets/avatar.dart';

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

    //perform logout
    if (doSignOut == true) {
      _signOut(context);
    }
  }

  Widget _buildUserInfo(User user) => Column(
        children: [
          Avatar(
            radius: 50,
            imageUrl: user.imageUrl,
            borderColor: Colors.black54,
          ),
          SizedBox(
            height: 8,
          ),
          if (user.name != null)
            Text(
              user.name,
              style: TextStyle(color: Colors.white),
            ),
          SizedBox(
            height: 8,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
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
        //ACCOUNT
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(user),
        ),
      ),
      body: Container(),
    );
  }
}
