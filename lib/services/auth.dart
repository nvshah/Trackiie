import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

///Generice class, User, used to represent FirebaseUser at our side (local)
///So that we can decoupled public interface of this Auth class from the Firebase
///So we will refernce Auth class for User object only.
class User {
  final String uid;
  User({@required this.uid});
}

///To define the features of Public-Interface, we are defining abstract class
///We will use this as Authentication API, in the rest of the part
abstract class AuthBase {
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
  Future<User> signInViaGoogle();
  Future<User> signInViaFacebook();
  Future<User> createUserViaEmailAndPassword({String email, String password});
  Future<User> signInViaEmailAndPassword({String email, String password});
}

///Provide Authentication related services
///Depenedency Injection - instead of Global Access
class Auth implements AuthBase {
  //Singleton
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebaseUser(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebaseUser(authResult.user);
  }

  @override
  Future<User> signInViaGoogle() async {
    //Get Access Token from google first, that can be used later to get user from firebase
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      //access token from google
      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
      //get user from firebase with the help of recieved google's access token
      final authResult = await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ),
      );
      return _userFromFirebaseUser(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User> signInViaFacebook() async {
    final facebookLogin = FacebookLogin();
    final result =
        await facebookLogin.logInWithReadPermissions(['public_profile']);
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        ),
      );
      return _userFromFirebaseUser(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User> signInViaEmailAndPassword({
    String email,
    String password,
  }) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebaseUser(authResult.user);
  }

  @override
  Future<User> createUserViaEmailAndPassword({
    String email,
    String password,
  }) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebaseUser(authResult.user);
  }

  @override
  Future<void> signOut() async {
    //As we need to sign out frm google as well else it's access token will be retained
    //and despite sign out from firebase, but having google access token Sign In will occur automatically
    //becuase google sign out is not happen & so ...
    final googleSignIn =
        GoogleSignIn(); // this instance can be shared out as class property but as it's expensive so its kept at method level
    await googleSignIn.signOut(); //Sign out current goole account

    final facebookSignIn = FacebookLogin();
    await facebookSignIn.logOut(); // Log out from current fb accont

    await _firebaseAuth.signOut();
  }

  //custom modelling/ from remote structure
  User _userFromFirebaseUser(FirebaseUser firebaseUser) {
    return firebaseUser == null ? null : User(uid: firebaseUser.uid);
  }

  //Useful to react when user signs in or signs out - without taking help from landing-page & doing some call-back there
  @override
  Stream<User> get onAuthStateChanged {
    //Convert Stream of Firebase User to Stream of User & then returns (i.e Type Safety since we are using Stream<T>)
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // Stream get onAuthStateChanged{
  //   return _firebaseAuth.onAuthStateChanged;
  // }
}
