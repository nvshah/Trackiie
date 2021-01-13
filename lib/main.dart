import 'package:flutter/material.dart';

import 'package:time_tracker/services/auth_provider.dart';
import './screens/landing_page.dart';
import './services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.pinkAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LandingPage(
          auth: Auth(),
        ),
      ),
    );
  }
}
