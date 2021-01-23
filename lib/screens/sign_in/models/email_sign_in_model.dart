import 'package:time_tracker/screens/sign_in/utils/validators.dart';

enum EmailSignInFormType {
  signin,
  signup,
}

class EmailSignInModel with EmailAndPasswordValidators {
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool isSubmitted;

  EmailSignInModel({
    this.email,
    this.password,
    this.formType = EmailSignInFormType.signin,
    this.isLoading = false,
    this.isSubmitted = false,
  });

  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
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
}
