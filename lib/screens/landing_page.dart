import 'package:flutter/material.dart';

import './sign_in/sign_in_page.dart';
import './home_page.dart';
import '../services/auth.dart';

class LandingPage extends StatelessWidget {
  final AuthBase auth;

  LandingPage({
    @required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (ctxt, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage(
              auth: auth,
            );
          }
          return HomePage(
            auth: auth,
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
