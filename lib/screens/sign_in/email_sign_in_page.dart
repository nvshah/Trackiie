import 'package:flutter/material.dart';

import 'package:time_tracker/screens/sign_in/email_sign_in_form.dart';
import '../../services/auth.dart';

class EmailSignInPage extends StatelessWidget {
  final AuthBase auth;

  EmailSignInPage({@required this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        //shadow effect  //default value is 4.0
        elevation: 2.0,
      ),
      //Inorder to avoid overflow error due to different device sizes (i.e when soft keyboard popus out, etc...)
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm(
              auth: auth,
            ),
          ),
        ),
      ),
      //shade-as we want
      backgroundColor: Colors.grey[200],
    );
  }
}
