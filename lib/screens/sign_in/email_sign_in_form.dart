import 'package:flutter/material.dart';

import 'package:time_tracker/screens/sign_in/sign_in_buttons.dart';
import '../../services/auth.dart';

enum EmailSignInFormType {
  signin,
  signup,
}

class EmailSignInForm extends StatefulWidget {
  final AuthBase auth;

  EmailSignInForm({@required this.auth});

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  EmailSignInFormType _formType = EmailSignInFormType.signin;

  void _submit() {}

  ///toggling form type between signin & register
  void _toogleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signin
          ? EmailSignInFormType.signup
          : EmailSignInFormType.signin;
    });
    _emailTextController.clear();
    _passwordTextController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signin
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signin
        ? 'Need an account? Register'
        : 'Have an account? SignIn';
    return [
      //EMAIL
      TextField(
        controller: _emailTextController,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@xyz.com',
        ),
      ),
      const SizedBox(
        height: 8.0,
      ),
      //PASSWORD
      TextField(
        controller: _passwordTextController,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
      ),
      const SizedBox(
        height: 8.0,
      ),
      //SIGN BUTTON
      FormSignInButton(
        text: primaryText,
        onPressed: _submit,
      ),
      const SizedBox(
        height: 8.0,
      ),
      //REGISTER
      FlatButton(
        onPressed: _toogleFormType,
        child: Text(secondaryText),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
