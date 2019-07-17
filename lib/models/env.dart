import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

const String URL_ENV = ".env.json";

class EnvParser {
  Future<Env> load() async {
    String jsonContent = await rootBundle.loadString(URL_ENV);
    return Env.fromJson(json.decode(jsonContent));
  }
}

class Env {
  final String apiUrl;
  final int deviceId;
  final String accessTokenKey;
  final String refreshTokenKey;
  final String expiresInKey;

  Env({
    this.apiUrl,
    this.deviceId,
    this.accessTokenKey,
    this.refreshTokenKey,
    this.expiresInKey,
  });

  factory Env.fromJson(Map<String, dynamic> jsonMap) {
    return new Env(
      apiUrl: jsonMap["API_URL"],
      deviceId: jsonMap["DEVICE_ID"],
      accessTokenKey: jsonMap["ACCESS_TOKEN_STORAGE_KEY"],
      refreshTokenKey: jsonMap["REFRESH_TOKEN_STORAGE_KEY"],
      expiresInKey: jsonMap["EXPIRES_IN_STORAGE_KEY"],
    );
  }
}
