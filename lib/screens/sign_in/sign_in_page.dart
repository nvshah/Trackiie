import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:time_tracker/screens/sign_in/email_sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/widgets/platform_exception_alert_dialog.dart';
import 'sign_in_buttons.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;

  ///toggles the value of current loading state
  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  ///show alert dialog on some error
  void _showSignInError(PlatformException exception, BuildContext context) {
    //display error, unless signIn aborted by an user (checking error code)
    if (exception.code != 'ERROR_ABORTED_BY_USER') {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: exception,
      ).show(context);
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      _toggleLoading(); //show loading
      final auth = Provider.of<AuthBase>(context);
      await auth.signInAnonymously();
      //print('${authResult.user.uid}');
    } on PlatformException catch (e) {
      _showSignInError(e, context);
    } finally {
      _toggleLoading(); //remove loading
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      _toggleLoading(); //show loading
      final auth = Provider.of<AuthBase>(context);
      await auth.signInViaGoogle();
      //print('${authResult.user.uid}');
    } on PlatformException catch (e) {
      _showSignInError(e, context);
    } finally {
      _toggleLoading(); //remove loading
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      _toggleLoading(); //show loading
      final auth = Provider.of<AuthBase>(context);
      await auth.signInViaFacebook();
      //print('${authResult.user.uid}');
    } on PlatformException catch (e) {
      _showSignInError(e, context);
    } finally {
      _toggleLoading(); //remove loading
    }
  }

  void _signInWithEmail(BuildContext ctxt) {
    Navigator.of(ctxt).push(
      MaterialPageRoute<void>(
        //fullscreendialog- value decides if new screen appear from bottom or slide from right in IOS apps
        //     : For android its always coming up from bottom
        fullscreenDialog: true,
        builder: (_) => EmailSignInPage(),
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
          //HEADER - Sign In Text or Loading Indicator
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          // Trick- to give padding
          SizedBox(height: 48.0),
          //Google Sign-In button
          SocialSignInButton(
            text: "Sign in with Google",
            assetName: "images/google-logo.png",
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: _isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0), // Trick- to give padding
          //Facebook Sign-In button
          SocialSignInButton(
            text: "Sign in with Facebook",
            assetName: "images/facebook-logo.png",
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: _isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(height: 8.0), // Trick- to give padding
          //Email Sign-In button
          SignInButton(
            text: "Sign in with Email",
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: _isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: _isLoading ? null : () => _signInAnonymously(context),
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

  ///build header either text or loading indicator
  Widget _buildHeader() {
    if (_isLoading) {
      //LOADING Indicator
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    //SIGN IN - label
    return Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
