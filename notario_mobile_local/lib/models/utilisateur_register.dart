class UtilisateurRegister {
  UtilisateurRegister({
    required this.LastName,
    required this.age,
    required this.email,
    required this.firstName,
    required this.password,
    required this.password_confirm,
    this.phone,
  });

  String email;
  String password;
  String password_confirm;
  String? phone;
  String firstName;
  String LastName;
  String age;

  Map<String, dynamic> toData() {
    return {
      'email': email,
      'password': password,
      'password_confirm': password_confirm,
      'phone': phone,
      'firstName': firstName,
      'LastName': LastName,
      'age': age,
    };
  }

  bool get passwordIsConfirm => password == password_confirm;
}
