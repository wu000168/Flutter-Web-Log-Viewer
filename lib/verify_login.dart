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

  void _setVerified(bool verified) {
    setState(() {
      _verifying = false;
      _verified = verified;
    });
  }

  Future<bool> _verifyUser(Map params) async {
    http.Response response = await http.get(
      Uri.http(ServerInfo.host, OAuthInfo.verifyUserPath,
          {OAuthInfo.codeKey: params[OAuthInfo.codeKey]}),
    );
    Map responseBody = jsonDecode(response.body);
    return (responseBody["errcode"] == 0 &&
        responseBody["errmsg"] == "ok" &&
        responseBody.containsKey("UserId"));
  }

  @override
  void initState() {
    super.initState();
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
      // TODO: Mobile Login
      _setVerified(false);
    }
    _setVerified(true); // to bypass login
  }

  @override
  Widget build(BuildContext context) {
    if (_verifying) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_verified) {
      return widget.pageSuccess;
    } else {
      return LoginFailureLanding();
    }
  }
}
