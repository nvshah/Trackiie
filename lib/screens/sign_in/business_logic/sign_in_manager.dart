import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:time_tracker/services/auth.dart';

class SignInManager {
  SignInManager({
    @required this.auth,
    this.isLoading,
  });
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  ///Sign In via any 3rd party or anonymous procedure
  Future<User> _signIn(Future<User> Function() signInMethod) async {
    //Update ValueNotifeir value
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      //Here we need to make this false as we're going to stay on same page &
      // landing page ain't goign to replace the sign_in page i.e no rebuild of new screen
      // So this catch bloc is always going to execute
      //_setIsLoading(false);
      isLoading.value = false;
      rethrow;
    } finally {
      //As when sign in succeeds sign in page is going to be replaced by Home page So it's gonna to be disposed
      // So no need to set SetIsLoading false then (In case signIn Succeeds)
      // Another reason not to use below line is becuase ahead Landing page is rebuildin g the signIn page again on successful sign in,
      // in which case this below line may not run earlier than that page build
      // So page gets disposed & finally BLOC may or may not be executed
      //_setIsLoading(false);
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle() async => await _signIn(auth.signInViaGoogle);
  Future<User> signInWithFB() async => await _signIn(auth.signInViaFacebook);
}
