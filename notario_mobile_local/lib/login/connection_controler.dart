import 'package:http/src/response.dart';
import 'package:notario_mobile/api/api_auth.dart';
import 'package:notario_mobile/models/utilisateur_login.dart';
import 'package:notario_mobile/utils/constants/contants_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionControler {
  ConnectionControler({
    this.email = '',
    this.password = '',
    required this.apiAuth,
  });

  final ApiAuth apiAuth;
  String email;
  String password;
  bool stayLoggedIn = false;

  void changeEmail(String newEmail) {
    email = newEmail;
  }

  void changePassword(String newPassword) {
    password = newPassword;
  }

  Future<Response> connection() async {
    try {
      Response response = await apiAuth.apiLogin(
          utilisateurLogin: UtilisateurLogin(email: email, password: password));
      
      if (response.statusCode == 200 && stayLoggedIn) {
        await saveCredentials();
      }

      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('stayLoggedIn', stayLoggedIn);
  await prefs.setString('email', email);
  await prefs.setString('password', password);
  await prefs.setString('token', TokenUser);
  await prefs.setString('type', typeUser);
  await prefs.setString('state', stateUser);
}


  Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String? token = prefs.getString('token');
    if (token != null) {
      TokenUser = token;
    }

    String? type = prefs.getString('type');
    if (type != null) {
      typeUser = type;
    }

    String? state = prefs.getString('state');
    if (state != null) {
      stateUser = state;
    }

    bool? stayLoggedInPref = prefs.getBool('stayLoggedIn');
    if (stayLoggedInPref == true) {
      stayLoggedIn = true;
      email = prefs.getString('email') ?? '';
      password = prefs.getString('password') ?? '';
    } else {
      stayLoggedIn = false;
    }
  }
}
