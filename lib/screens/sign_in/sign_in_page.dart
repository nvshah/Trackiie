import 'package:flutter/material.dart';

import 'package:time_tracker/screens/sign_in/email_sign_in_page.dart';
import 'sign_in_buttons.dart';
import '../../services/auth.dart';

class SignInPage extends StatelessWidget {
  final AuthBase auth;

  SignInPage({
    @required this.auth,
  });

  Future<void> _signInAnonymously() async {
    //TODO: Sign In Anonymously
    try {
      await auth.signInAnonymously();
      //print('${authResult.user.uid}');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    //TODO: Sign In With Google
    try {
      await auth.signInViaGoogle();
      //print('${authResult.user.uid}');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook() async {
    //TODO: Sign In With facebook
    try {
      await auth.signInViaFacebook();
      //print('${authResult.user.uid}');
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext ctxt) {
    Navigator.of(ctxt).push(
      MaterialPageRoute<void>(
        //fullscreendialog- value decides if new screen appear from bottom or slide from right in IOS apps
        //     : For android its always coming up from bottom
        fullscreenDialog: true,
        builder: (_) => EmailSignInPage(
          auth: auth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Time Tracker'),
          //shadow effect  //default value is 4.0
          elevation: 2.0),
      body: _buildContent(context),
      //shade-as we want
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
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
          SizedBox(height: 48.0),
          //Google Sign-In button
          SocialSignInButton(
            text: "Sign in with Google",
            assetName: "images/google-logo.png",
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: _signInWithGoogle,
          ),
          SizedBox(height: 8.0), // Trick- to give padding
          //Facebook Sign-In button
          SocialSignInButton(
            text: "Sign in with Facebook",
            assetName: "images/facebook-logo.png",
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: _signInWithFacebook,
          ),
          SizedBox(height: 8.0), // Trick- to give padding
          //Email Sign-In button
          SignInButton(
            text: "Sign in with Email",
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0), // Trick- to give padding
          //OR text
          Text(
            "Or",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          //Anonymuous Sign-In button
          SignInButton(
            text: "Go Anonymous",
            textColor: Colors.black,
            color: Colors.limeAccent[300],
            onPressed: _signInAnonymously,
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
