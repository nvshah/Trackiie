import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String body;

  const EmptyContent(
      {Key key, this.title = 'Nothing Here', this.body = 'Add some tasks...!'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 32,
            ),
          ),
          Text(
            body,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
