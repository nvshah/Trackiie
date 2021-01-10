import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './platform_widget.dart';

class PlatformAwareDialog extends PlatformWidget {
  final String title;
  final String content;
  final String defaultActionText;

  PlatformAwareDialog({
    @required this.title,
    @required this.content,
    @required this.defaultActionText,
  });

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      PlatformAlertDialogAction(
        onPressed: () => Navigator.of(context).pop(),
        child: Text('OK'),
      ),
    ];
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;

  PlatformAlertDialogAction({
    this.child,
    this.onPressed,
  });

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext contexntext) {
    return FlatButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
