class UtilisateurRegister {
  UtilisateurRegister({
    required this.LastName,
    required this.age,
    required this.email,
    required this.firstName,
    required this.password,
    required this.password_confirm,
    required this.token,
    required this.phone,
  });

  String token;
  String email;
  String password;
  String password_confirm;
  String phone;
  String firstName;
  String LastName;
  String age;

  Map<String, dynamic> toData() {
    return {
      'recaptcha': "9b3dd17e-8d72-4ea1-91e2-d285e1584a3c-8392a8e8-4b89-4f1b-8356-8ab9a2f9d4f2",
      'email': email,
      'password': password,
      'password_confirm': password_confirm,
      'phone': phone,
      'first_name': firstName,
      'last_name': LastName,
      'age': age,
    };
  }

  bool get passwordIsConfirm => password == password_confirm;
}
