import 'package:notario_mobile/api/api_auth.dart';
import 'package:http/src/response.dart';
import 'package:notario_mobile/models/utilisateur_register.dart';

class RegisterControler {
  RegisterControler({
    required this.LastName,
    required this.age,
    required this.email,
    required this.firstName,
    required this.password,
    required this.password_confirm,
    this.phone,
    required this.apiAuth,
  });

  final ApiAuth apiAuth;
  String email;
  String password;
  String password_confirm;
  String? phone;
  String firstName;
  String LastName;
  String age;

  void changeName(String newName) {
    firstName = newName;
  }

  void changeLastName(String newLastName) {
    firstName = newLastName;
  }

  void changeEmail(String newEmail) {
    email = newEmail;
  }

  void changePassword(String newPassword) {
    password = newPassword;
  }

  void changePasswordConfirm(String newPassword_confirm) {
    password_confirm = newPassword_confirm;
  }

  void changeAge(String newAge) {
    age = newAge;
  }

  void changePhone(String newPhone) {
    age = newPhone;
  }

  Future<Response> register() async {
    try {
      return apiAuth.apiRegister(
          utilisateurRegister: UtilisateurRegister(
              LastName: LastName,
              age: age,
              email: email,
              firstName: firstName,
              password: password,
              password_confirm: password_confirm,
              phone: phone));
    } catch (e) {
      print('test');
      throw e;
    }
  }
}
