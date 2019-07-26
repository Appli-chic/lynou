import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/models/api_error.dart';

main() {
  test('ApiError - from json', () {
    Map<String, dynamic> json = Map();
    json["code"] = 0;
    json["message"] = "Un message";

    var apiError = ApiError.fromJson(json);
    expect(apiError.code, 0);
    expect(apiError.message, "Un message");
  });
}
