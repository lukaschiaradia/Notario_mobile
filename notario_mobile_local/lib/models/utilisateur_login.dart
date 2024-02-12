class UtilisateurLogin {
  UtilisateurLogin({
    required this.email,
    required this.password,
  });

  String email;
  String password;

  Map<String, dynamic> toData() {
    return {
      'email': email,
      'password': password,
      'recaptcha': '9b3dd17e-8d72-4ea1-91e2-d285e1584a3c-8392a8e8-4b89-4f1b-8356-8ab9a2f9d4f2',
    };
  }
}
