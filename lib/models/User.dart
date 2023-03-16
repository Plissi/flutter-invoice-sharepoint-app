import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transmission_facture_client/environment.dart';

class User {
  String username;
  String password;

  User(this.username, this.password);

  factory User.fromJson(Map<String, dynamic> json){
    return User(json['username'], json['password']);
  }
}

Future<http.Response> login(User user) async{
  Uri uri = Environment.uriLogin;

  final response = await http.post(
    uri,
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'username': user.username,
      'password': user.password
    }),
  );

  return response;
}