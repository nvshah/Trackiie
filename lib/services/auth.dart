import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

///Generice class, User, used to represent FirebaseUser at our side (local)
///So that we can decoupled public interface of this Auth class from the Firebase
///So we will refernce Auth class for User object only.
class User{
  final String uid;
  User({@required this.uid});
}

///To define the features of Public-Interface, we are defining abstract class
///We will use this as Authentication API, in the rest of the part
abstract class AuthBase{
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<void> signOut();
}

///Depenedency Injection - instead of Global Access
class Auth implements AuthBase {

  final _firebaseAuth = FirebaseAuth.instance;
  
  @override
  Future<User> currentUser() async{
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebaseUser(user);
  }
  
  @override
  Future<User> signInAnonymously() async{
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebaseUser(authResult.user);
  }

  @override
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  User _userFromFirebaseUser(FirebaseUser firebaseUser){
    return firebaseUser == null ? null : User(uid: firebaseUser.uid); 
  }
}