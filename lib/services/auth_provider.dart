import 'package:flutter/material.dart';

import 'auth.dart';

class AuthProvider extends InheritedWidget {
  AuthProvider({
    Key key,
    this.child,
    this.auth,
  }) : super(key: key, child: child);

  final Widget child;
  final AuthBase auth;

  static AuthBase of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthProvider>().auth;
  }

  @override
  bool updateShouldNotify(AuthProvider oldWidget) => false;
}
