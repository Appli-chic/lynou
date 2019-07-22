import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lynou/models/api_error.dart';
import 'package:lynou/models/env.dart';
import 'package:lynou/models/token.dart';

const String AUTH_LOGIN = "/auth/login";
const String AUTH_SIGNUP = "/auth/register";

const int ERROR_SERVER = 0;
const int ERROR_EMAIL_PASSWORD_NOT_MATCHING = 1;
const int ERROR_EMAIL_ALREADY_EXISTS = 2;
const int ERROR_PASSWORD_NOT_IDENTICAL = 3;
const int ERROR_WRONG_TOKEN = 4;

class AuthService {
  final Env env;

  AuthService({
    this.env,
  });

  /// Login the user with an [email] and a [password]
  /// If the login success, it stores the refresh token, access token and the time
  /// before it expires.
  ///
  /// Throws [ApiError] if the [email] or [password] is wrong.
  Future<void> login(String email, String password) async {
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
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  /// Signup the user with an [email], [name], [password] and a [verifyPassword]
  /// If the sign up success, it stores the refresh token, access token and the time
  /// before it expires.
  ///
  /// Throws [ApiError] if the [email] already exists.
  Future<void> signUp(
      String email, String name, String password, String verifyPassword) async {
    var client = new http.Client();
    var response = await client.post("${env.apiUrl}$AUTH_SIGNUP", body: {
      "email": email,
      "name": name,
      "password": password,
      "verifyPassword": verifyPassword,
      "deviceId": env.deviceId.toString()
    });

    if (response.statusCode == 201) {
      // Retrieve the tokens
      final storage = new FlutterSecureStorage();
      Token token = Token.fromJson(json.decode(response.body));

      // Store the tokens
      await storage.write(key: env.accessTokenKey, value: token.accessToken);
      await storage.write(key: env.refreshTokenKey, value: token.refreshToken);
      await storage.write(
          key: env.expiresInKey, value: token.expiresIn.toString());
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  /// Check if the user is logged in by checking if it has an access token
  Future<bool> isLoggedIn() async {
    final storage = new FlutterSecureStorage();
    final accessToken = await storage.read(key: env.accessTokenKey);

    if (accessToken != null && env.accessTokenKey.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
