import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:time_tracker/app/home/pages/home_page.dart';
import 'package:time_tracker/services/database.dart';
import './sign_in/sign_in_page.dart';
import '../services/auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Avoid rebuilding of landing page when Navigation stack changes
    //So not listening to the parents
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (ctxt, snapshot) {
        // active means atleast 1 item from stream is fetched
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            //return SignInPage();
            return SignInPage.create(
                context); // create page with all configurations needed (i.e bloc)
          }
          //already signed in then to home Page
          return Provider<User>.value(
            value: user,
            child: Provider<Database>(
              create: (_) => FireStoreDatabase(uid: user.uid),
              child: HomePage(),
            ),
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
