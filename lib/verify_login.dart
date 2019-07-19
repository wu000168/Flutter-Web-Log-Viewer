import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_web/material.dart';
import 'package:log_viewer/config/config.dart';
import 'package:log_viewer/login_failure_landing.dart';

class VerifyLogin extends StatefulWidget {
  final Widget pageSuccess;
  VerifyLogin({@required this.pageSuccess});

  @override
  _VerifyLoginState createState() => _VerifyLoginState();
}

class _VerifyLoginState extends State<VerifyLogin> {
  bool _verifying = true, _verified = false;
  String _message;

  void _setVerified(bool verified) {
    html.window.sessionStorage['authd'] = verified.toString();
    setState(() {
      _verifying = false;
      _verified = verified;
    });
  }

  Future<bool> _verifyUser(Map params) async {
    http.Response response = await http.get(
      Uri.https(ServerInfo.host, OAuthInfo.verifyUserPath,
          {OAuthInfo.codeKey: params[OAuthInfo.codeKey]}),
    );
    Map responseBody = jsonDecode(response.body);
    _message = responseBody["errmsg"];
    return (responseBody["errcode"] == 0 &&
        responseBody["errmsg"] == "ok" &&
        responseBody.containsKey("UserId"));
  }

  @override
  void initState() {
    super.initState();
    if (html.window.sessionStorage['authd'] == true.toString()) {
      _setVerified(true);
      return;
    }
    String query = html.window?.location?.search;
    if (query != null && query != "") {
      Map params = Map.fromEntries(query.substring(1).split('&').map((param) {
        List paramKeyVal = param.split('=').map(Uri.decodeComponent).toList();
        return MapEntry<String, dynamic>(paramKeyVal[0], paramKeyVal[1]);
      }));
      _verifyUser(params)
          .then(_setVerified, onError: (e) => _setVerified(false))
          .timeout(Duration(seconds: 7), onTimeout: () => false);
    } else {
      if (!identical(0, 0.0)) {
        // if (!kIsWeb)
        _setVerified(true);
        // TODO: Mobile Login
      }
      _setVerified(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return widget.pageSuccess; // to bypass login
    if (_verifying) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_verified) {
      return widget.pageSuccess;
    } else {
      return LoginFailureLanding(message: _message);
    }
  }
}
