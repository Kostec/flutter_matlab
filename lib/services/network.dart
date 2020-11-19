import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Network{
//  static String site = 'http://10.0.8.98';
//  static String site = 'http://127.0.0.1:8000';
  static String site = 'https://test-sim-matlab.herokuapp.com';
  static String Token = '';

  static void Get() async {
    String url = '$site/hello/';
    var response = await http.get(url);
    print('${response.statusCode}: ${response.body}');
  }

  static Future<void> Login(String login, String password) async{
    String url = '$site/login/';
    var body = {
      'username' : login,
      'password' : password,
    };
    Map<String, String> headers = {'Content-Type': 'application/json'};
    var response = await http.post(url, body: jsonEncode(body), headers: headers);
    if (response.statusCode == 200) {
      var map = jsonDecode(response.body);
      var user = map['user'];
      Token = map['Token'];
      var auth = map['auth'];
    }
  }

  static Future<void> SignUp(Map body) async{
    String url = '$site/registration/';
    var headers = <String, String>{ 'Content-Type': 'application/json' };
    var response = await http.post(url, body: json.encode(body), headers: headers);
    if (response.statusCode == 200) {
      var map = jsonDecode(response.body);
      var user = map['user'];
      Token = map['Token'];
      var auth = map['auth'];
    }
  }
}