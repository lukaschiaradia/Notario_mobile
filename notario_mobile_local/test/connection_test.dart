import 'package:flutter_test/flutter_test.dart';
import 'package:notario_mobile/api/api.dart';
import 'package:notario_mobile/api/api_auth.dart';
import 'package:notario_mobile/models/utilisateur_login.dart';

void main() {
  test('connection_success', () async {
    final result = await ApiAuth().apiLogin(
        utilisateurLogin:
            UtilisateurLogin(email: 'test@test.com', password: 'Orus33240'));
    print("work");
    Future.delayed(Duration(seconds: 5));
    expectLater(result.statusCode, 200);
  });
}


//  test('connection_fail', () async {
//    final result =
//        await api_login(email: 'lukas.chiaradia@epitech.eu', password: 'b');
//    await expectLater(result, 400);
//  });
