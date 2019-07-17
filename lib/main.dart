import 'package:flutter_web/material.dart';
import 'package:log_viewer/verify_login.dart';
import 'package:log_viewer/viewer_body.dart';

void main() => runApp(ViewerApp());

class ViewerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Log Viewer",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VerifyLogin(
        pageSuccess: ViewerBody(),
      ),
    );
  }
}
