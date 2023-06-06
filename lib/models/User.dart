import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:memory_cache/memory_cache.dart';
import 'package:transmission_facture_client/environment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String username;
  String password;

  User(this.username, this.password);

  factory User.fromJson(Map<String, dynamic> json){
    return User(json['username'], json['password']);
  }
}

Future<Map<String, Object?>> login(User user) async{
  Uri uri = Environment.uriLogin;
  try{
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

    final prefs = await SharedPreferences.getInstance();

    if (response.statusCode == 200) {
      var parsed = json.decode(response.body);
      prefs.setString("token", parsed["token"]);
      prefs.setString("expiration", parsed["expiration"]);

      return {
        'ok' : true
      };
    }else{
      return {
        'ok' : false,
        'error': "Nom d'utilisateur et/ou mot de passe incorrect"
      };
    }
  } /*on TimeoutException catch(e){
    return {
      'ok' : false,
      'error': e.message
    };
  }*/ catch (err){
    return {
      'ok' : false,
      'error': err.toString()
    };
  }

}