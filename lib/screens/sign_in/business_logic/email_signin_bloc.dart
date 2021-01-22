import 'dart:async';

import 'package:time_tracker/screens/sign_in/models/email_sign_in_model.dart';

class EmailSignInBloc {
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

  void close() {
    _modelController.close();
  }
}
