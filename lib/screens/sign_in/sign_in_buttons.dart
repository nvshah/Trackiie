import 'package:flutter/material.dart';

import '../../widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  //Constructor a way to supply all the parameter
  SignInButton({
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
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

class SocialSignInButton extends CustomRaisedButton {
  //Constructor a way to supply all the parameter
  SocialSignInButton({
    @required String text, //Otherwise text Widget will throw an error
    Color color,
    Color textColor,
    VoidCallback onPressed, // We can pass null call back intentionally
    @required
        String assetName, // We required this else there will be error/warning
  })  : assert(text != null),
        assert(assetName != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //Image
              Image.asset(assetName),
              //Text
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15.0,
                ),
              ),
              //Hack - to make Text at Center
              //inorder to centered our text widget we are adding image-dummy
              Opacity(
                opacity: 0,
                child: Image.asset(assetName),
              ),
            ],
          ),
          color: color,
          //height: 40.0,
          onPressed: onPressed,
        );
}

class FormSignInButton extends CustomRaisedButton {
  final String text;
  final VoidCallback onPressed;

  FormSignInButton({
    this.onPressed,
    @required this.text,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: Colors.indigo,
          borderRadius: 4.0,
          onPressed: onPressed,
        );
}
