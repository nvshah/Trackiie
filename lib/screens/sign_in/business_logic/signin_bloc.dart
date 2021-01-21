import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:time_tracker/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});
  final AuthBase auth;

  final StreamController<bool> _isLoadingController = StreamController<bool>();

  ///get loading state stream
  Stream<bool> get getLoadingStream => _isLoadingController.stream;

  ///close the underlying stream
  void dispose() {
    _isLoadingController.close();
  }

  ///Set a loading state
  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  ///Sign In via any 3rd party or anonymous procedure
  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle() async => await _signIn(auth.signInViaGoogle);
  Future<User> signInWithFB() async => await _signIn(auth.signInViaFacebook);
}
