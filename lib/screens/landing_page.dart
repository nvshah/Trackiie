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
    widget.auth.onAuthStateChanged.listen((user) {
      print('user: ${user?.uid}');
    });
  }

  //Callback - that update user after sign in completes or signout completes
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
    return StreamBuilder<User>(
      stream: widget.auth.onAuthStateChanged,
      builder: (ctxt, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage(
              onSignIn: _updateUser,
              auth: widget.auth,
            );
          }
          return HomePage(
            onSignOut: () => _updateUser(null),
            auth: widget.auth,
          );
        } else {
          //Loading... For 1st time it may take a while while communicating with the firebase server
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
    // return _user == null
    //     ? SignInPage(
    //         onSignIn: _updateUser,
    //         auth: widget.auth,
    //       )
    //     : HomePage(
    //         onSignOut: () => _updateUser(null),
    //         auth: widget.auth,
    //       );
  }
}
