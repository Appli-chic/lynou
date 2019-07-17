import 'package:flutter/material.dart';

class Token {
  final int expiresIn;
  final String accessToken;
  final String refreshToken;

  Token({
    @required this.expiresIn,
    @required this.accessToken,
    @required this.refreshToken,
  });

  factory Token.fromJson(Map<String, dynamic> jsonMap) {
    return new Token(
      expiresIn: jsonMap["expiresIn"],
      accessToken: jsonMap["accessToken"],
      refreshToken: jsonMap["refreshToken"],
    );
  }
}
