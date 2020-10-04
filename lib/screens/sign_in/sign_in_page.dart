import 'package:flutter/material.dart';

import '../../widgets/custom_raised_button.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Time Tracker'),
          //shadow effect  //default value is 4.0
          elevation: 2.0),
      body: _buildContent(),
      //shade-as we want
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      //color: Colors.yellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //SIGN IN - label
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
          // Trick- to give padding
          SizedBox(height: 8.0),
          //Google Sign-In button
          CustomRaisedButton(
            child: Text(
              'Sign in with Google',
              style: TextStyle(color: Colors.black87, fontSize: 15.0,),
            ),
            color: Colors.white,
            borderRadius: 4.0,
            onPressed: (){},
          ),
          // //Trick- to give padding
          // SizedBox(height: 8.0),
          // Container(
          //   color: Colors.red,
          //   child: SizedBox(
          //     height: 100.0,
          //   ),
          // ),
        ],
      ),
    );
  }
}
