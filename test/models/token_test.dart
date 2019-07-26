import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/models/token.dart';

main() {
  test('Token - from json', () {
    Map<String, dynamic> json = Map();
    json["expiresIn"] = 60;
    json["accessToken"] = "access token";
    json["refreshToken"] = "refresh token";

    var token = Token.fromJson(json);
    expect(token.expiresIn, 60);
    expect(token.accessToken, "access token");
    expect(token.refreshToken, "refresh token");
  });
}
