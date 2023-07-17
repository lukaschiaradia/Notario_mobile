import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/src/response.dart';
import 'package:notario_mobile/api/api.dart';
import 'package:notario_mobile/api/api_auth.dart';
import 'package:notario_mobile/login/connection_controler.dart';
import 'package:notario_mobile/models/utilisateur_login.dart';

class StubApiAuth extends ApiAuth {
  @override
  Future<Response> apiLogin({required UtilisateurLogin utilisateurLogin}) {
    // TODO: implement apiLogin
    return Future.value(Response("", 200));
  }
}

class StubApiAuthFailed extends ApiAuth {
  @override
  Future<Response> apiLogin({required UtilisateurLogin utilisateurLogin}) {
    // TODO: implement apiLogin
    throw Exception("error");
  }
}

void main() {
  test('connection_success', () async {
    final result =
        await ConnectionControler(apiAuth: StubApiAuth()).connection();
    expect(result.statusCode, 200);
  });

  test('connection_failed', () async {
    expect(
        () async => await ConnectionControler(apiAuth: StubApiAuthFailed())
            .connection(),
        throwsA(isA<Exception>()));
  });

  test('changeMail_success', () async {
 final connectionControler = ConnectionControler(apiAuth: ApiAuth());
      connectionControler.changeEmail("test@test.com");
    expect(connectionControler.email, "test@test.com");
  });

    test('changePassword_success', () async {
 final connectionControler = ConnectionControler(apiAuth: ApiAuth());
      connectionControler.changePassword("test");
    expect(connectionControler.password, "test");
  });
}
