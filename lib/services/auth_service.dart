import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lynou/models/token.dart';
import 'package:lynou/utils/env.dart';

const String AUTH_LOGIN = "/auth/login";

class AuthService {
  final Env env;

  AuthService({
    this.env,
  });

  Future<dynamic> login(String email, String password) async {
    var client = new http.Client();
    var response = await client.post("${env.apiUrl}$AUTH_LOGIN", body: {
      "email": email,
      "password": password,
      "deviceId": env.deviceId.toString()
    });

    if (response.statusCode == 200) {
      // Retrieve the tokens
      final storage = new FlutterSecureStorage();
      Token token = Token.fromJson(json.decode(response.body));

      // Store the tokens
      await storage.write(key: env.accessTokenKey, value: token.accessToken);
      await storage.write(key: env.refreshTokenKey, value: token.refreshToken);
      await storage.write(
          key: env.expiresInKey, value: token.expiresIn.toString());
      print("Yeaaaaah");
    } else {
      print("Nooooooo");
    }
  }
}
