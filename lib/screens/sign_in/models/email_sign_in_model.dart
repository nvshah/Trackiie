enum EmailSignInFormType {
  signin,
  signup,
}

class EmailSignInModel {
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
}
