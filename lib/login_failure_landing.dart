import 'dart:html' as html;
import 'package:flutter_web/material.dart';

class LoginFailureLanding extends StatelessWidget {
  final String message;
  LoginFailureLanding({this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.highlight_off,
              size: 128,
              color: Theme.of(context).errorColor,
            ),
            if (message != null)
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Text(message),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(
          Icons.arrow_back,
        ),
        onPressed: () => html.window.location.href = "/",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
