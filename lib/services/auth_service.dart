import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lynou/models/api_error.dart';
import 'package:lynou/models/env.dart';
import 'package:http/http.dart' as http;
import 'package:lynou/models/token.dart';

const String AUTH_LOGIN = "/api/auth/login";
const String AUTH_SIGNUP = "/api/auth";
const String AUTH_REFRESH_TOKEN = "/api/auth/refresh";

const String ERROR_EMAIL_OR_PASSWORD_INCORRECT =
    "CODE_ERROR_EMAIL_OR_PASSWORD_INCORRECT";
const String ERROR_EMAIL_ALREADY_EXISTS = "CODE_ERROR_EMAIL_ALREADY_EXISTS";
const String ERROR_SERVER = "CODE_ERROR_SERVER";

class AuthService {
  var client = http.Client();
  final Env env;

  AuthService({
    this.env,
  });

  /// Login the user with an [email] and a [password]
  ///
  /// Throws [ApiError] if the [email] or [password] is wrong.
  Future<void> login(String email, String password) async {
    var response = await client.post("${env.apiUrl}$AUTH_LOGIN",
        body: json.encode({
          "email": email,
          "password": password,
        }));

    if (response.statusCode == 200) {
      // Retrieve the tokens
      final storage = FlutterSecureStorage();
      Token token = Token.fromJson(json.decode(response.body));

      // Store the tokens
      await storage.write(key: env.accessTokenKey, value: token.accessToken);
      await storage.write(key: env.refreshTokenKey, value: token.refreshToken);
      await storage.write(
          key: env.expiresInKey, value: token.expiresIn.toString());

      // Add the timer to refresh the token
      refreshAccessTokenTimer(token.expiresIn);
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  /// Signup the user with an [email], [name], [password]
  ///
  /// Throws [ApiError] if the [email] already exists.
  Future<void> signUp(String email, String name, String password) async {
    var response = await client.post("${env.apiUrl}$AUTH_SIGNUP",
        body:
            json.encode({"email": email, "name": name, "password": password}));

    if (response.statusCode == 201) {
      // Retrieve the tokens
      final storage = FlutterSecureStorage();
      Token token = Token.fromJson(json.decode(response.body));

      // Store the tokens
      await storage.write(key: env.accessTokenKey, value: token.accessToken);
      await storage.write(key: env.refreshTokenKey, value: token.refreshToken);
      await storage.write(
          key: env.expiresInKey, value: token.expiresIn.toString());

      // Add the timer to refresh the token
      refreshAccessTokenTimer(token.expiresIn);
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  /// Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: env.accessTokenKey);
//    await storage.delete(key: env.accessTokenKey);

    if (accessToken != null && env.accessTokenKey.isNotEmpty) {
      // Add the timer to refresh the token
      try {
        await refreshAccessToken();
      } catch (e) {}
      return true;
    } else {
      return false;
    }
  }

  // Retrieve the access token
  Future<String> getAccessToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: env.accessTokenKey);
  }

  // Refresh the access token each time it delayed
  Future<void> refreshAccessToken() async {
    final storage = FlutterSecureStorage();
    final refreshToken = await storage.read(key: env.refreshTokenKey);

    var response = await client.post("${env.apiUrl}$AUTH_REFRESH_TOKEN",
        body: json.encode({"refreshToken": refreshToken}));

    if (response.statusCode == 200) {
      // Retrieve the tokens
      Token token = Token.fromJson(json.decode(response.body));

      // Store the tokens
      await storage.write(key: env.accessTokenKey, value: token.accessToken);
      refreshAccessTokenTimer(token.expiresIn);
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  // A timer to refresh the access token one minute before it expires
  refreshAccessTokenTimer(int time) async {
    var newTime = time - 60000; // Renew 1min before it expires
    await Future.delayed(Duration(milliseconds: newTime));
    await refreshAccessToken();
    refreshAccessTokenTimer(time);
  }
}
