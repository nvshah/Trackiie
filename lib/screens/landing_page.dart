import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './sign_in/sign_in_page.dart';
import './home_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  //Callback
  void _updateUser(FirebaseUser user) {
    //print('User -> ${user.uid}');
    setState(() {
      _user = user;
    });
  }
  
  ///Check if currenlty user is signed in
  Future<void> _getCurrentUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
     _user = user; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return _user == null
        ? SignInPage(
            onSignIn: _updateUser,
          )
        : HomePage(
            onSignOut: () => _updateUser(null),
          );
  }
}
