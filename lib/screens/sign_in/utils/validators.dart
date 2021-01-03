abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

//We will use this as mixin on email sign in page to utilise the servcies
class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final invalidEmailErrorText = "Email can't be empty";
  final invalidPasswordErrorText = "Password can't be empty";
}
