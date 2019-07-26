import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/models/env.dart';
import 'package:lynou/services/auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

main() {
  var _env = Env();

  setUp(() {
    _env = Env(
      apiUrl: 'apiUrl',
      deviceId: 1,
      accessTokenKey: 'accessTokenKey',
      refreshTokenKey: 'refreshTokenKey',
      expiresInKey: 'expiresInKey',
    );
  });

  testWidgets('AuthService - Check the login', (WidgetTester tester) async {
    final client = MockClient();
    var authService = AuthService(env: _env);

    when(client.post("${authService.env.apiUrl}$AUTH_LOGIN", body: {
      "email": "email",
      "password": "password",
      "deviceId": authService.env.deviceId.toString()
    })).thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

    authService.client = client;

    // try {
    //   await authService.login("email", "password");
    //   expect(true, true);
    // } catch (e) {
    //   expect(true, false);
    // }
  });
}
