import 'dart:async';

import 'package:time_tracker/screens/sign_in/models/email_sign_in_bloc_model.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInBloc {
  final AuthBase auth;

  EmailSignInBloc({this.auth});

  final StreamController<EmailSignInBlocModel> _modelController =
      StreamController<EmailSignInBlocModel>();
  Stream<EmailSignInBlocModel> get modelStream => _modelController.stream;
  //To Keep track of latest model
  var _model = EmailSignInBlocModel();

  ///Update current model
  void updateModelWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) {
    //Update Model
    _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      isSubmitted: isSubmitted,
    );
    // Add model to stream
    _modelController.add(_model);
  }

  //Submit Form details
  Future<void> submit() async {
    updateModelWith(isLoading: true, isSubmitted: true);
    try {
      await ((_model.formType == EmailSignInFormType.signin)
          ? auth.signInViaEmailAndPassword(
              email: _model.email,
              password: _model.password,
            )
          : auth.createUserViaEmailAndPassword(
              email: _model.email,
              password: _model.password,
            ));
    } catch (e) {
      //we need to update model only when sign in fails as if we succeed we're going to dismiss this page anyway
      updateModelWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateModelWith(email: email);
  void updatePassword(String password) => updateModelWith(password: password);

  void toogleFormType() {
    final formType = _model.formType == EmailSignInFormType.signin
        ? EmailSignInFormType.signup
        : EmailSignInFormType.signin;
    //Reset form data
    //NOTE : We must sync val between TextEditingController & Model of bloc i.e
    //       Every time we clear text we must also clear value in our model
    updateModelWith(
      email: '',
      password: '',
      isLoading: false,
      isSubmitted: false,
      formType: formType,
    );
  }

  void close() {
    _modelController.close();
  }
}
