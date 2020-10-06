import 'package:flutter/material.dart';

import '../../widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  //Constructor a way to supply all the parameter
  SignInButton({
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15.0,
            ),
          ),
          color: color,
          //height: 40.0,
          onPressed: onPressed,
        );
}
