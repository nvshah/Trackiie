import 'package:flutter/cupertino.dart';
import 'package:time_tracker/screens/sign_in/utils/validators.dart';
import 'package:time_tracker/services/auth.dart';

enum EmailSignInFormType {
  signin,
  signup,
}

class EmailSignInChangeNotifierModel
    with EmailAndPasswordValidators, ChangeNotifier {
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool isSubmitted;
  AuthBase auth;

  EmailSignInChangeNotifierModel({
    this.email,
    this.password,
    this.formType = EmailSignInFormType.signin,
    this.isLoading = false,
    this.isSubmitted = false,
    @required this.auth,
  });

  void updateModelWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.isSubmitted = isSubmitted ?? this.isSubmitted;
    notifyListeners();
  }

  String get primaryButtonText =>
      formType == EmailSignInFormType.signin ? 'Sign in' : 'Create an account';

  String get secondaryButtonText => formType == EmailSignInFormType.signin
      ? 'Need an account? Register'
      : 'Have an account? SignIn';

  ///Check if EmailSignIn form can be submitted successfully
  bool get canSubmit =>
      emailValidator.isValid(email) &&
      passwordValidator.isValid(password) &&
      !isLoading;

  String get passwordErrorText {
    //submitted atleast once, then show error
    final showErrorText = isSubmitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    //submitted atleast once, then show error
    final showErrorText = isSubmitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  //------ Business Logic Methods ----------

  void updateEmail(String email) => updateModelWith(email: email);
  void updatePassword(String password) => updateModelWith(password: password);

  void toogleFormType() {
    final formType = this.formType == EmailSignInFormType.signin
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

  //Submit Form details
  Future<void> submit() async {
    updateModelWith(isLoading: true, isSubmitted: true);
    try {
      await ((formType == EmailSignInFormType.signin)
          ? auth.signInViaEmailAndPassword(
              email: email,
              password: password,
            )
          : auth.createUserViaEmailAndPassword(
              email: email,
              password: password,
            ));
    } catch (e) {
      //we need to update model only when sign in fails as if we succeed we're going to dismiss this page anyway
      updateModelWith(isLoading: false);
      rethrow;
    }
  }
}
