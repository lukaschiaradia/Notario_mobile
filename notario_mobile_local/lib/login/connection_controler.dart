import 'package:http/src/response.dart';
import 'package:notario_mobile/api/api_auth.dart';
import 'package:notario_mobile/models/utilisateur_login.dart';

class ConnectionControler {
  ConnectionControler({
    this.email = '',
    this.password = '',
    required this.apiAuth,
  });

  final ApiAuth apiAuth;
  String email;
  String password;

  void changeEmail(String newEmail) {
    email = newEmail;
  }

  void changePassword(String newPassword) {
    password = newPassword;
  }

  Future<Response> connection() async {
    try {
      return apiAuth.apiLogin(
          utilisateurLogin: UtilisateurLogin(email: email, password: password));
    } catch (e) {
      throw e;
    }
  }
}
