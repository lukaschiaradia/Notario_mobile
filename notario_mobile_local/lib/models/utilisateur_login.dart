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
    };
  }
}
