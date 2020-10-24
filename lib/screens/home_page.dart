import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  final VoidCallback onSignOut;

  HomePage({@required this.onSignOut});

  Future<void> _signOut() async {
    try{
      final authResult = await FirebaseAuth.instance.signOut();
      //Signaling Landing Page
      onSignOut();
    }catch (e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app,), onPressed: _signOut,),
        ],
      ),
    );
  }
}