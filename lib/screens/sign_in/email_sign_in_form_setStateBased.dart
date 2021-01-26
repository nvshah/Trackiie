import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:time_tracker/screens/sign_in/sign_in_buttons.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/widgets/platform_exception_alert_dialog.dart';
import 'utils/validators.dart';
import 'package:time_tracker/screens/sign_in/models/email_sign_in_bloc_model.dart';

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
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

  //We will show error only when user once submit the details.
  bool _submitted = false;

  //Inorder to not send multiple request simultaneously one after another before response of earlier one arrives
  //Disable form until response is retrieved from server/firebase
  bool _loading = false;

  //AuthBase auth;

  @override
  void initState() {
    super.initState();
    //auth = AuthProvider.of(context);
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  //Submit Form details
  void _submit() async {
    setState(() {
      _submitted = true;
      _loading = true;
    });
    try {
      //Inside Stateful widget we always have an access to 'context' anywhere
      //inside stateless widget we need to pass around instead
      final auth = Provider.of<AuthBase>(context);
      await ((_formType == EmailSignInFormType.signin)
          ? auth.signInViaEmailAndPassword(email: _email, password: _password)
          : auth.createUserViaEmailAndPassword(
              email: _email, password: _password));
      //IF Sign In or Register is Succesfully done then dismiss the screen automatically
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      //display alert dialog
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
      //print(e.toString());
      // if (Platform.isIOS) {
      // } else {}
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: Text('Sign in failed'),
      //       content: Text(e.toString()),
      //       actions: <Widget>[
      //         FlatButton(
      //             onPressed: () => Navigator.of(context).pop(),
      //             child: Text('OK')),
      //       ],
      //     );
      //   },
      // );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  ///toggling form type between signin & register
  void _toogleFormType() {
    setState(() {
      //Reset Entire form State
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signin
          ? EmailSignInFormType.signup
          : EmailSignInFormType.signin;
    });
    _emailTextController.clear();
    _passwordTextController.clear();
  }

  ///after user press next or enter from keyboard then decide what to do next
  void _emailEditingComplete() {
    //When there is error and we press next/enter then stay on same field instead going next field
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Widget _buildEmailInputField() {
    //submitted atleast once, then show error
    final showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailTextController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@xyz.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: !_loading,
      ),
      autocorrect: false, //No suggestion for Email
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      //When we press enter or complete entering text& enter next button from keyboard
      //Move focus to password field
      onEditingComplete: () => _emailEditingComplete,
      onChanged: (_) => _updateState(),
    );
  }

  Widget _buildPasswordInputField() {
    //submitted atleast once, then show error
    final showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordTextController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: !_loading,
      ),
      obscureText: true,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete:
          _submit, //Submit form once password field is completed on taking inputs
      onChanged: (_) => _updateState(),
    );
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signin
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signin
        ? 'Need an account? Register'
        : 'Have an account? SignIn';

    //bool _submitEnabled = _email.isNotEmpty && _password.isNotEmpty;
    bool _submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_loading;

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
        onPressed: _submitEnabled ? _submit : null,
      ),
      const SizedBox(
        height: 8.0,
      ),
      //SECONDARY
      FlatButton(
        onPressed: !_loading ? _toogleFormType : null,
        child: Text(secondaryText),
      ),
      const SizedBox(
        height: 8.0,
      ),
      if (_loading)
        Center(
          child: CircularProgressIndicator(),
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

  void _updateState() {
    setState(() {});
  }
}
