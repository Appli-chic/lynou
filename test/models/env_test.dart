import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/models/env.dart';

main() {
  test('Env - from json', () {
    Map<String, dynamic> json = Map();
    json["API_URL"] = "URL";
    json["DEVICE_ID"] = 1;
    json["ACCESS_TOKEN_STORAGE_KEY"] = "ACCESS_TOKEN";
    json["REFRESH_TOKEN_STORAGE_KEY"] = "REFRESH_TOKEN";
    json["EXPIRES_IN_STORAGE_KEY"] = "EXPIRES_IN";

    var env = Env.fromJson(json);
    expect(env.apiUrl, "URL");
    expect(env.deviceId, 1);
    expect(env.accessTokenKey, "ACCESS_TOKEN");
    expect(env.refreshTokenKey, "REFRESH_TOKEN");
    expect(env.expiresInKey, "EXPIRES_IN");
  });
}
