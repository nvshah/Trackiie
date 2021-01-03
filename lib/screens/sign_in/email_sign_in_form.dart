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
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  EmailSignInFormType _formType = EmailSignInFormType.signin;

  String get _email => _emailTextController.text;
  String get _password => _passwordTextController.text;

  //Submit Form details
  void _submit() async {
    try {
      await ((_formType == EmailSignInFormType.signin)
          ? widget.auth
              .signInViaEmailAndPassword(email: _email, password: _password)
          : widget.auth.createUserViaEmailAndPassword(
              email: _email, password: _password));
      //IF Sign In or Register is Succesfully done then dismiss the screen automatically
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

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

  Widget _buildEmailInputField() {
    return TextField(
      controller: _emailTextController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@xyz.com',
      ),
      autocorrect: false, //No suggestion for Email
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      //When we press enter or complete entering text& enter next button from keyboard
      //Move focus to password field
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
    );
  }

  Widget _buildPasswordInputField() {
    return TextField(
      controller: _passwordTextController,
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete:
          _submit, //Submit form once password field is completed on taking inputs
    );
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
      _buildEmailInputField(),
      const SizedBox(
        height: 8.0,
      ),
      //PASSWORD
      _buildPasswordInputField(),
      const SizedBox(
        height: 8.0,
      ),
      //PRIMARY
      FormSignInButton(
        text: primaryText,
        onPressed: _submit,
      ),
      const SizedBox(
        height: 8.0,
      ),
      //SECONDARY
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
