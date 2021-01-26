import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:time_tracker/screens/sign_in/sign_in_buttons.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker/screens/sign_in/models/email_sign_in_bloc_model.dart';
import 'package:time_tracker/screens/sign_in/business_logic/email_sign_in_bloc.dart';

class EmailSignInForm extends StatefulWidget {
  final EmailSignInBloc bloc;
  EmailSignInForm(this.bloc);

  //Inorder to accomodate BLOC
  static Widget create(BuildContext context) {
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: Provider.of<AuthBase>(context)),
      dispose: (context, bloc) => bloc.close(),
      child: Consumer(
        builder: (ctxt, bloc, _) => EmailSignInForm(bloc),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  //NOTE texteditingcontroller hilds the state so this formPage must be stateful widget
  //(it cannot be converted to stateless widget as it's not pure widget. i.e it has side effects, Eg TextEditingController)
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

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
    try {
      await widget.bloc.submit();
      //IF Sign In or Register is Succesfully done then dismiss the screen automatically
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      //display alert dialog
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  ///toggling form type between signin & register
  void _toogleFormType() {
    //Reset form data
    //NOTE : We must sync val between TextEditingController & Model of bloc i.e
    //       Every time we clear text we must also clear value in our model
    widget.bloc.toogleFormType();
    _emailTextController.clear();
    _passwordTextController.clear();
  }

  ///after user press next or enter from keyboard then decide what to do next
  void _emailEditingComplete(EmailSignInBlocModel model) {
    //When there is error and we press next/enter then stay on same field instead going next field
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Widget _buildEmailInputField(EmailSignInBlocModel model) {
    return TextField(
      controller: _emailTextController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@xyz.com',
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
      ),
      autocorrect: false, //No suggestion for Email
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      //When we press enter or complete entering text& enter next button from keyboard
      //Move focus to password field
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: widget
          .bloc.updateEmail, //Widget rebuild != Widget render (widget redrawn)
    );
  }

  Widget _buildPasswordInputField(EmailSignInBlocModel model) {
    return TextField(
      controller: _passwordTextController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
      ),
      obscureText: true,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete:
          _submit, //Submit form once password field is completed on taking inputs
      onChanged: widget.bloc
          .updatePassword, //Widget rebuild != Widget render (widget redrawn)
    );
  }

  List<Widget> _buildChildren(EmailSignInBlocModel model) {
    return [
      //EMAIL
      _buildEmailInputField(model),
      const SizedBox(
        height: 8.0,
      ),
      //PASSWORD
      _buildPasswordInputField(model),
      const SizedBox(
        height: 8.0,
      ),
      //PRIMARY
      FormSignInButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      const SizedBox(
        height: 8.0,
      ),
      //SECONDARY
      FlatButton(
        onPressed: !model.isLoading ? _toogleFormType : null,
        child: Text(model.secondaryButtonText),
      ),
      const SizedBox(
        height: 8.0,
      ),
      if (model.isLoading)
        Center(
          child: CircularProgressIndicator(),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInBlocModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInBlocModel(),
        builder: (context, snapshot) {
          final model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }
}
