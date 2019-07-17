import 'package:flutter_web/material.dart';
import 'dart:html' as html;

class LoginFailureLanding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    html.window.history.back(); // relog?
    return Scaffold(
      appBar: null,
      body: Center(
        child: Icon(
          Icons.highlight_off,
          color: Colors.red,
        ),
      ),
    );
  }
}
