import 'package:flutter/material.dart';

import '../services/auth.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onSignOut;
  final AuthBase auth;

  HomePage({
    @required this.onSignOut,
    @required this.auth,
  });
  
  Future<void> _signOut() async {
    try {
      await auth.signOut();
      //Signaling Landing Page
      onSignOut();
    } catch (e) {
      print(e.toString());
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
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }
}
