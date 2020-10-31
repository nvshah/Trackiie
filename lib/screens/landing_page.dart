import 'package:flutter/material.dart';

import './sign_in/sign_in_page.dart';
import './home_page.dart';
import '../services/auth.dart';

class LandingPage extends StatefulWidget {
  final AuthBase auth;

  LandingPage({
    @required this.auth,
  });

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  //Callback
  void _updateUser(User user) {
    //print('User -> ${user.uid}');
    setState(() {
      _user = user;
    });
  }

  ///Check if currenlty user is signed in
  Future<void> _getCurrentUser() async {
    User user = await widget.auth.currentUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _user == null
        ? SignInPage(
            onSignIn: _updateUser,
            auth: widget.auth,
          )
        : HomePage(
            onSignOut: () => _updateUser(null),
            auth: widget.auth,
          );
  }
}
