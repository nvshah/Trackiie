import 'dart:async';

import 'package:time_tracker/screens/sign_in/models/email_sign_in_model.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInBloc {
  final AuthBase auth;

  EmailSignInBloc({this.auth});

  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  //To Keep track of latest model
  var _model = EmailSignInModel();

  ///Update current model
  void updateWith({
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
  void submit() async {
    updateWith(isLoading: true, isSubmitted: true);
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
    } catch (e) {} finally {
      updateWith(isLoading: false);
    }
  }

  void close() {
    _modelController.close();
  }
}
