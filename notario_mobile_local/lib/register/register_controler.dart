import 'package:notario_mobile/api/api.dart';
import 'package:notario_mobile/api/api_auth.dart';
import 'package:http/src/response.dart';
import 'package:notario_mobile/models/utilisateur_register.dart';

class RegisterController {
  RegisterController({
    this.LastName = '',
    this.age = '',
    this.email = '',
    this.firstName = '',
    this.password = '',
    this.password_confirm = '',
    this.token = '',
    this.phone = '',
    required this.apiAuth,
  });

  final ApiAuth apiAuth;
  String token = '"9b3dd17e-8d72-4ea1-91e2-d285e1584a3c-8392a8e8-4b89-4f1b-8356-8ab9a2f9d4f2"';
  String email;
  String password;
  String password_confirm;
  String phone;
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
              phone: phone,
              token: token));
    } catch (e) {
      throw e;
    }
  }
}
